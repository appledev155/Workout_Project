import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/bloc/setting/basic_info_form_bloc.dart';
import 'package:anytimeworkout/life_cycle_handler.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/upload_progress_bloc/upload_progress_bloc.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/repo/chat_repo.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:anytimeworkout/isar/app_config/app_config.dart' as app_config_store;
import 'package:anytimeworkout/isar/app_config/app_config_isar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:pubnub/pubnub.dart';
import '../../model/user_model.dart';
import '../../repository/item_api_provider.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

part 'current_user_event.dart';
part 'current_user_state.dart';

app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  // Broadcast from Current Bloc
  StreamController appUserStream = StreamController<UserModel>.broadcast();
  StreamController appChatRepoStream =
      StreamController<CurrentUserState>.broadcast();
  StreamController appEnvelopStream = StreamController<Envelope>.broadcast();
  StreamController uploadProgressStream =
      StreamController<UploadBox>.broadcast();

  StreamSubscription<Envelope>? _envelopmentSubscriptionStream;
  StreamSubscription<PresenceEvent>? _presenceSubscriptionStream;
  StreamSubscription<UploadBox>? _uploadProgressStream;

  late ChannelState channelState;

  UploadProgressBloc uploadProgressBloc;

  CurrentUserBloc({required loggedUser, required this.uploadProgressBloc})
      : super(
          loggedUser.id == null
              ? const CurrentUserState.unauthenticated()
              : CurrentUserState.authenticated(loggedUser),
        ) {
    on<IsAuthorized>(_onIsAuthorized, transformer: sequential());
    on<UpdateProfile>(_onUpdateProfile, transformer: sequential());
    on<PubNubEvent>(_onPubNubEvent);
    on<UploadEvent>(_onUploadEvent);
    on<LogOutRequest>(_onLogOutRequest, transformer: sequential());
    on<GetPushNotificatoinPermission>(_onGetPushNotificatoinPermission);

    if (state.currentUser!.id.toString() != '0') {
      _envelopmentSubscriptionStream =
          state.chatRepo?.envelopeController.stream.listen((envelope) {
        add(PubNubEvent(envelope));
      });

      // TO DO as this is not needed any more.
      _uploadProgressStream = uploadProgressBloc.uploadStream.stream.listen(
        (event) {
          add(UploadEvent(event));
        },
        onError: (err) {
          print('uploadProgressBloc Error!');
        },
        cancelOnError: false,
        onDone: () {
          print('uploadProgressBloc Done!');
        },
      );
    }
  }

  _onUploadEvent(UploadEvent event, Emitter<CurrentUserState> emit) {
    CurrentUserState.copyWith(
      currentUser: state.currentUser,
      chatRepo: state.chatRepo,
      status: state.status,
      uploadBox: event.uploadBox,
    );
    uploadProgressStream.add(event.uploadBox);
  }

  _onPubNubEvent(PubNubEvent event, Emitter<CurrentUserState> emit) {
    appEnvelopStream.sink.add(event.envelope);
    // envelope events
    if (event.envelope.content.runtimeType == List &&
        event.envelope.uuid.toString() == state.currentUser!.id.toString()) {
      envelopeEvents(event.envelope);
    }
  }

  envelopeEvents(Envelope envelope) async {
    if (envelope.messageType == MessageType.normal) {
      dynamic decodedContent = jsonDecode(envelope.content.toString());
      dynamic message = decodedContent[0]['text'];

      if (message['cardType'] == "userMerged") {
        add(const LogOutRequest());
      }

      if (message['cardType'] == "updateUserNotification") {
        dynamic messageData = message['data'];
        dynamic decodedMessageData = jsonDecode(messageData.toString());
        String userId = decodedMessageData['userId'];
        String? getCurrentUser =
            await app_instance.storage.read(key: "JWTUser");
        dynamic decodedCurrentUser = jsonDecode(getCurrentUser.toString());
        final getUserDetails = await app_instance.itemApiProvider
            .getUserProfile(userId.toString());
        dynamic currentUserObject = {
          "id": decodedCurrentUser['id'],
          "uid": decodedCurrentUser['uid'],
          "displayName": getUserDetails['displayName'],
          "email": getUserDetails['email'],
          "phoneNumber": getUserDetails['phoneNumber'],
          "role_id": getUserDetails['role_id'],
          "emailVerified": getUserDetails['emailVerified'],
          "phoneVerified": getUserDetails['phoneVerified'],
          "property_area_unit": decodedCurrentUser['property_area_unit'],
          "agency_id": decodedCurrentUser['agency_id'],
          "photo_url": getUserDetails['photo_url'],
          "is_deleted": decodedCurrentUser['is_deleted'],
          "userkey": decodedCurrentUser['userkey'],
          "token": decodedCurrentUser['token']
        };
        await app_instance.utility.updateJwtUser(currentUserObject);
        add(const UpdateProfile(deleteAccount: false));
        BasicInfoFormBloc().getProfile();
      }
    }
  }

  _onUpdateProfile(UpdateProfile event, Emitter<CurrentUserState> emit) async {
    String? getCurrentUser = await app_instance.storage.read(key: "JWTUser");
    if (getCurrentUser != null) {
      if (event.deleteAccount == true) {
        app_instance.userRepository.deleteAccount();
        add(const LogOutRequest());
      } else {
        UserModel currentUser = UserModel.recJson(jsonDecode(getCurrentUser));
        emit(CurrentUserState.authenticated(currentUser));
        appUserStream.sink.add(currentUser);
        appChatRepoStream.sink.add(state);
      }
    }
  }

  _onIsAuthorized(IsAuthorized event, Emitter<CurrentUserState> emit) async {
    try {
      String? getCurrentUser = await app_instance.storage.read(key: "JWTUser");
      if (getCurrentUser == null) {
        await state.chatRepo?.cancelSubscription();
        // _onLogOutRequest();
        appChatRepoStream.sink.add(state);
        await savePushNotificationToken(isDelete: true);
        emit(const CurrentUserState.unauthenticated());
      } else {
        UserModel currentUser = UserModel.recJson(jsonDecode(getCurrentUser));
        emit(CurrentUserState.authenticated(currentUser));
        appUserStream.sink.add(currentUser);
        appChatRepoStream.sink.add(state);

        // VERIFY SUBSCRIPTION HAPPEN ONCE PER LOGIN
        // print(
        //     "app_instance.appConfig.firstBoot ---- ${app_instance.appConfig.firstBoot} ${app_instance.appConfig.firstBoot.runtimeType}");

        dynamic getSubscribedChannelList =
            await state.chatRepo?.getSubscribedChannelList();

        List<dynamic> chatChannel = getSubscribedChannelList["channels"];
        Set<String> channelNameSet = {
          ...chatChannel.map((e) => e["friendlyName"].toString())
        };

        try {
          await state.chatRepo?.subscribeChannel(channelNameSet);
        } catch (e, stackTrace) {
          print('''e: $e \n stackTrace: $stackTrace''');
        }

        await savePushNotificationToken();
        _envelopmentSubscriptionStream =
            state.chatRepo?.envelopeController.stream.listen((envelope) {
          add(PubNubEvent(envelope));
        });
      }
    } catch (e, stackTrace) {
      print('''e: $e \n stackTrace: $stackTrace''');
    }
  }

  _onGetPushNotificatoinPermission(GetPushNotificatoinPermission event,
      Emitter<CurrentUserState> emit) async {
    await savePushNotificationToken();
  }

  savePushNotificationToken({bool isDelete = false}) async {
    try {
      final notificationSettings =
          await FirebaseMessaging.instance.requestPermission();
      String? deviceTokenStored =
          await appConfigStore.fetchConfig(configName: 'deviceToken');
      String? deviceToken = deviceTokenStored;

      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          deviceTokenStored.runtimeType != Null) {
        if (Platform.isIOS) {
          deviceToken = await FirebaseMessaging.instance.getAPNSToken();
        } else {
          deviceToken = await FirebaseMessaging.instance.getToken();
        }

        if (deviceToken != deviceTokenStored) {
          await app_instance.appConfigStore.saveAppConfig(AppConfigIsar()
            ..configName = 'deviceToken'
            ..configValue = deviceToken.toString());
        }
      }
      if ((deviceTokenStored.runtimeType == Null &&
              deviceToken.runtimeType != Null) ||
          (deviceTokenStored.runtimeType != Null &&
              deviceTokenStored != deviceToken)) {
        await app_instance.storage
            .write(key: "deviceToken", value: deviceToken.toString());
        app_instance.userRepository.updateDeviceToken(
          isDelete: isDelete,
          currentDeviceToken: deviceToken.toString(),
          prevDeviceToken: deviceTokenStored.toString(),
        );
      }
    } catch (er, _) {
      if (kDebugMode) {
        print("savePushNotificationToken $er");
      }
    }
  }

  dispose() {
    appUserStream.close();
    appEnvelopStream.close();
    uploadProgressStream.close();
  }

  Future<void> _onLogOutRequest(
      LogOutRequest event, Emitter<CurrentUserState> emit) async {
    state.chatRepo?.endSubscription();
    await app_instance.isarServices.cleanDb();
    app_instance.storage.delete(key: "JWTUser");
    return;
  }
}
