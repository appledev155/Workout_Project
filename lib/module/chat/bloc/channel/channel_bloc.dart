import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/isar/app_config/app_config_isar.dart';
import 'package:anytimeworkout/isar/channel/channel_isar.dart';
import 'package:anytimeworkout/isar/message/message_isar.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pubnub/pubnub.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';

import '../../../../isar/user/user_isar.dart';
import '../../config/chat_config.dart';
import '../../../../model/user_model.dart';
import '../../model/chat_model.dart';
import '../../repo/chat_repo.dart';

import 'package:stream_transform/stream_transform.dart';

/// Isar Packages
import 'package:anytimeworkout/isar/user/user.dart' as user_store;
import 'package:anytimeworkout/isar/message/message_row.dart' as message_store;
import 'package:anytimeworkout/isar/channel/channel.dart' as channel_store;
import 'package:anytimeworkout/isar/app_config/app_config.dart' as app_config_store;

import 'package:anytimeworkout/config.dart' as app_instance;

/// Isar Packages

part 'channel_event.dart';
part 'channel_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  StreamController appUserStream = StreamController<UserModel>.broadcast();
  StreamController appChatRepoStream =
      StreamController<CurrentUserState>.broadcast();

  late final CurrentUserBloc currentUserBloc;

  late UserModel? currentUser;
  late ChatRepo chatRepo;

  ChatUser _chatUser;
  ChatUser get chatUser => _chatUser;

  user_store.User userStore = user_store.User();
  message_store.MessageRow messageStore = message_store.MessageRow();
  channel_store.Channel channelStore = channel_store.Channel();
  app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();

  StreamSubscription<Envelope>? _envelopStreamChannelBloc;
  StreamSubscription<UserModel>? _currentUserStreamChannelBloc;
  StreamSubscription<CurrentUserState>? _chatRepoStreamChannelBloc;
  // StreamSubscription<Map<String, dynamic>>? _currentUserBoxesStream;

  ChannelBloc({required currentUserBloc})
      : currentUser = currentUserBloc.state.currentUser,
        chatRepo = currentUserBloc.state.chatRepo,
        _chatUser = ChatUser(
          userId: currentUserBloc.state.currentUser!.id.toString(),
          username: currentUserBloc.state.currentUser!.name.toString(),
          userImage: currentUserBloc.state.currentUser!.profileImage.toString(),
          roleTypeId: currentUserBloc.state.currentUser!.roleId.toString(),
        ),
        super(const ChannelState(status: ChannelStatus.localSyncStarted)) {
    // start with local Sync
    on<FetchFromStore>(_onFetchFromStore, transformer: sequential());
    // After local Done sync with Server
    on<ChannelSync>(_onChannelSync, transformer: sequential());
    on<UpdateChannelList>(_onUpdateChannelList, transformer: restartable());
    on<PrivateSubscribe>(_onPrivateSubscribe);
    on<NewChannelInitiate>(_onNewChannelInitiate, transformer: sequential());
    on<ChannelMessageReceived>(_onChannelMessageReceived);
    on<DeleteChannel>(_onDeleteChannel);
    on<MovedOnChatScreen>(_onMovedOnChatScreen, transformer: restartable());
    on<MovedChannelScreen>(_onMovedChannelScreen);
    on<SetCurrentActiveChannel>(_onSetCurrentActiveChannel);
    on<ChannelResetState>(_resetState, transformer: sequential());
    on<ChannelIndicator>(_onChannelIndicator);
    on<NewRequestCreated>(_onNewRequestCreated);
    on<UserProfileUpdate>(_onUserProfileUpdate);
    on<MessageUpdate>(_onMessageUpdate);
    on<DeleteChannels>(_onDeleteChannels);
    on<UserSignalSent>(_onUserSignalSent, transformer: sequential());
    on<DeleteChannelsByRequestId>(_onDeleteChannelsByRequestId);
    on<ClearDeletedUserData>(_onClearDeletedUserData);
    on<UpdateSingleChannel>(_onUpdateSingleChannel);
    on<ResetUnreadChannelCount>(_onResetUnreadChannelCount);
    on<ResumeEnvelopeStream>(_onResumeEnvelopeStream);

    _currentUserStreamChannelBloc =
        currentUserBloc.appUserStream.stream.listen((currentUserEvent) {
      _chatUser = ChatUser(
        userId: currentUserEvent!.id.toString(),
        username: currentUserEvent!.name.toString(),
        userImage: currentUserEvent!.profileImage.toString(),
        roleTypeId: currentUserEvent!.roleId.toString(),
      );
      currentUser = currentUserEvent;
    });

    _chatRepoStreamChannelBloc = currentUserBloc.appChatRepoStream.stream
        .listen((currentUserStateEvent) {
      chatRepo = currentUserStateEvent.chatRepo;
    });

    _envelopStreamChannelBloc =
        currentUserBloc.appEnvelopStream.stream.listen((envelope) {
      if (envelope.channel == "my-channel-${chatUser.userId}" ||
          envelope.uuid.toString() != chatUser.userId) {
        envelopEvents(envelope);
      }
    });
  }

  dynamic getCardTypeWithMessage(messageContent) {
    dynamic messageFormatForEvent;
    dynamic cardType = "";
    dynamic sendCardTypeWithMessage;

    if (messageContent.content.runtimeType.toString() == "List<dynamic>") {
      messageFormatForEvent = messageContent.content.first;
      dynamic messageData = jsonDecode(messageFormatForEvent);
      cardType = messageData['text'];
    } else {
      messageFormatForEvent = messageContent.content;
      if (messageContent.messageType == MessageType.normal) {
        dynamic messageData = jsonDecode(messageFormatForEvent);
        cardType = jsonDecode(messageData['text']);
      } else {
        cardType = {'cardType': 'signal'};
      }
    }

    sendCardTypeWithMessage = {
      "cardType": cardType['cardType'],
      "messageFormatForEvent": messageFormatForEvent
    };

    return sendCardTypeWithMessage;
  }

  /// Envelop to sync the events from of channel
  envelopEvents(envelope) async {
    switch (envelope.messageType) {
      case MessageType.normal:
        // Send the envelop back for last visited channel respective of timetoken
        dynamic messageAndCard = getCardTypeWithMessage(envelope);
        // delete user request notification
        if (messageAndCard['cardType'] == "deleteChannelsNotification") {
          add(
            DeleteChannels(
              notificationData: jsonEncode(messageAndCard),
              notificationType: messageAndCard['cardType'],
            ),
          );
        }

        // notification for added new property
        if (messageAndCard['cardType'] == "newPropertyNotification") {
          await app_instance.storage
              .write(key: 'defaultSearch', value: 'false');
        }

        // user delete notification - clear channel related to this user
        if (messageAndCard['cardType'] == "userDeleted") {
          dynamic decodedMessageFormat =
              jsonDecode(messageAndCard['messageFormatForEvent'].toString());
          dynamic notificationText = decodedMessageFormat['text'];
          dynamic decodedData = jsonDecode(notificationText['data']);
          String userId = decodedData['userId'].toString();
          add(ClearDeletedUserData(userId: userId));
        }

        if (messageAndCard['cardType'] == "deleteMessageNotification" ||
            messageAndCard['cardType'] == 'updateMessageNotification') {
          add(MessageUpdate(
              notificationData: jsonEncode(messageAndCard),
              notificationType: messageAndCard['cardType']));
        }
        if (state.lastVisitedChannel.lastMessageTime != "" &&
            envelope.channel == state.lastVisitedChannel.channelName &&
            BigInt.parse(envelope.timetoken.toString()) <
                BigInt.parse(state.lastVisitedChannel.lastMessageTime)) return;
        if (cardTypeList.contains(messageAndCard['cardType'])) {
          add(
            ChannelMessageReceived(
              message: messageAndCard['messageFormatForEvent'].toString(),
              senderUserId: envelope.uuid.toString(),
              channelName: envelope.channel,
              timetoken: envelope.timetoken.toString(),
            ),
          );
        } // to display the uuid of the sender

        if (messageAndCard['cardType'] == "updateProfileNotification" ||
            messageAndCard['cardType'] == "updateUserNotification" ||
            messageAndCard['cardType'] == "upgradeRequestNotification") {
          dynamic decodedMessageFormat =
              jsonDecode(messageAndCard['messageFormatForEvent'].toString());
          dynamic notificationText = decodedMessageFormat['text'];
          dynamic decodedData = jsonDecode(notificationText['data']);
          String userId = decodedData['userId'].toString();
          add(UserProfileUpdate(
              updatedProfileUserId: userId,
              notificationType: messageAndCard['cardType']));
        }

        if (messageAndCard['cardType'] == 'userNotification') {
          print('NewChannelInitiate--');
          add(
            NewChannelInitiate(
              message: messageAndCard['messageFormatForEvent'].toString(),
              userId: envelope.uuid.toString(),
              channelName: envelope.channel,
            ),
          );
        }
        break;
      case MessageType.signal:
        dynamic messageContents = jsonDecode(envelope.content);

        if (messageContents['signalType'] == '5' ||
            messageContents['signalType'] == '4') {
          Timer(const Duration(seconds: 2), () {
            add(
              UpdateSingleChannel(channelName: envelope.channel.toString()),
            );
          });
        }

        if (messageContents['sT'] == '8') {
          String userId = messageContents['uI'].toString();
          add(UserProfileUpdate(
              updatedProfileUserId: userId,
              notificationType: "updateProfileNotification"));
        } else if (envelope.uuid.toString() != currentUser!.id.toString()) {
          int currentSignal =
              int.parse(messageContents!["signalType"].toString());
          if (currentSignal <= 1 ||
              currentSignal == 4 ||
              currentSignal == 5 ||
              currentSignal == 6) {
            add(ChannelIndicator(
              channelName: envelope.channel,
              currentSignal: currentSignal,
              userId: envelope.uuid.toString(),
            ));
          }
        }

        break;
      default:
        print('${envelope.publishedBy} sent a message: ${envelope.content}');
    }
  }

  // clear channel and other data which is related to deleted user;
  _onClearDeletedUserData(
      ClearDeletedUserData event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.updating));

    state.channelList.removeWhere((channel) {
      dynamic decodedChannelData = jsonDecode(channel.channelData.toString());
      return (decodedChannelData['chat_user']['0'].toString() == event.userId ||
          decodedChannelData['chat_user']['1'].toString() == event.userId);
    });

    await channelStore.clearDeletedUserChannels(
        userId: event.userId.toString());

    emit(state.copyWith(
        status: ChannelStatus.success, channelList: state.channelList));
  }

  _onResetUnreadChannelCount(
      ResetUnreadChannelCount event, Emitter<ChannelState> emit) {
    emit(state.copyWith(status: ChannelStatus.updating));
    emit(state.copyWith(status: ChannelStatus.success, unreadChannelCount: 0));
  }

  _onUpdateSingleChannel(
      UpdateSingleChannel event, Emitter<ChannelState> emit) async {
    emit(
      state.copyWith(status: ChannelStatus.updating),
    );

    ChatChannel updatedChannel = ChatChannel.empty;
    MessageRow lastMessageRow = MessageRow.empty;

    dynamic getchannelDetails =
        await chatRepo.getChannelDetailsByName(event.channelName);

    if (getchannelDetails != '') {
      Map<dynamic, dynamic> channelDetails = getchannelDetails
          .map((key, value) => MapEntry(key, value?.toString()));

      state.channelList.removeWhere((element) =>
          element.channelName.toString() == event.channelName.toString());

      dynamic decodedLastMessage = '';
      if (channelDetails['last_message'].runtimeType == Null) {
        decodedLastMessage = jsonDecode(channelDetails['last_message']);

        dynamic getContent =
            jsonDecode(decodedLastMessage['content'].toString());

        ChatUser chatFromUser = await chatRepo.getChatUser(
            userId: decodedLastMessage['uuid'].toString());

        Message lastMessage = Message(
          userId: chatFromUser.userId,
          channelName: channelDetails['friendlyName'].toString(),
          timetoken: decodedLastMessage['timetoken'].toString(),
          content: MessageContent(
            cardType: getContent['cardType'],
            data: getContent['data'],
            timeStamp: decodedLastMessage['timetoken'].toString(),
          ),
        );

        String messageId =
            "${decodedLastMessage['uuid']}-${channelDetails['id'].toString()}-${decodedLastMessage['timetoken'].toString()}}";

        lastMessageRow = MessageRow(
          messageId: messageId,
          channelName: channelDetails['friendlyName'].toString(),
          message: lastMessage,
          chatUser: chatFromUser,
          timeStamp: decodedLastMessage['timetoken'].toString(),
        );
      }

      ChatUser chatToUser = await chatRepo.getChatUser(
          userId: (currentUser!.id.toString() ==
                  channelDetails['toUserId'].toString())
              ? channelDetails['fromUserId'].toString()
              : channelDetails['toUserId'].toString());

      updatedChannel = ChatChannel(
        channelId: channelDetails['id'].toString(),
        channelName: channelDetails['friendlyName'],
        lastMessageRow: lastMessageRow,
        typingIndicator: '',
        lastMessageTime: lastMessageRow == MessageRow.empty
            ? '0'
            : decodedLastMessage['timetoken'].toString(),
        unreadMessageCount: '0',
        chatFlag: channelDetails['chatFlag'].toString(),
        lastVisitTime: '',
        channelData: channelDetails['channelData'].toString(),
        chatUser: chatUser,
        chatToUser: [chatToUser],
        typingIndicatorStartTime: '',
        disableTypingMessage: '',
      );
    }

    state.channelList.add(updatedChannel);

    updateLocalStorage(updatedChannel);

    List<ChatChannel> channelList = state.channelList;

    channelList.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    emit(state.copyWith(
        status: ChannelStatus.success, channelList: state.channelList));
  }

  // Delete channels by request id
  _onDeleteChannelsByRequestId(
      DeleteChannelsByRequestId event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.updating));
    List<ChatChannel> channelList = state.channelList;
    channelList.forEach((element) {
      dynamic decodedChannelData = jsonDecode(element.channelData.toString());
      if (event.requestId == decodedChannelData['reference_id']) {
        channelStore.deleteChannel(channelId: int.parse(element.channelId));
      }
    });

    channelList.removeWhere((element) {
      dynamic decodedChannelData = jsonDecode(element.channelData.toString());
      return event.requestId == decodedChannelData['reference_id'];
    });

    emit(state.copyWith(
        status: ChannelStatus.success, channelList: channelList));
  }

  _onDeleteChannels(DeleteChannels event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.updating));
    dynamic decodedMessage = jsonDecode(event.notificationData);
    dynamic decodedMessageFormat =
        jsonDecode(decodedMessage['messageFormatForEvent'].toString());
    dynamic notificationText = decodedMessageFormat['text'];
    dynamic decodedData = jsonDecode(notificationText['data']);

    String deletedChannels = decodedData['channelIds'];
    List deletedChannelIdList = deletedChannels.split(',');
    List<ChatChannel> updatedChannelList = state.channelList;

    // remove channels
    deletedChannelIdList.forEach((deletedChannelId) {
      // remove channel from isar local db
      updatedChannelList.forEach((element) {
        if (element.channelId == deletedChannelId) {
          channelStore.deleteChannel(channelId: int.parse(deletedChannelId));
        }
      });
      // remove channel from state
      updatedChannelList
          .removeWhere((element) => element.channelId == deletedChannelId);
    });

    emit(state.copyWith(
        status: ChannelStatus.success, channelList: updatedChannelList));
  }

  _onMessageUpdate(MessageUpdate event, Emitter<ChannelState> emit) async {
    dynamic decodedMessage = jsonDecode(event.notificationData);
    dynamic decodedMessageFormat =
        jsonDecode(decodedMessage['messageFormatForEvent'].toString());
    dynamic notificationText = decodedMessageFormat['text'];
    dynamic decodedData = jsonDecode(notificationText['data']);
    String userId = decodedData['userId'].toString();

    // for delete message which is deleted by admin.
    if (event.notificationType == "deleteMessageNotification") {
      String messageId =
          "${decodedData['userId']}-${decodedData['channelId']}-${decodedData['timetoken']}";
      await messageStore.deleteMessageByMessageId(messageId);
    }
    // for update message
    if (event.notificationType == "updateMessageNotification") {
      String messageId =
          "${decodedData['userId']}-${decodedData['channelId']}-${decodedData['timetoken']}";
      dynamic getMessage = await chatRepo.getMessageForReply(messageId);
      dynamic decodedGetMessage = jsonDecode(getMessage['message']);
      ChatUser senderUser =
          await chatRepo.getChatUser(userId: decodedGetMessage['uuid']);
      dynamic messageContent = jsonDecode(decodedGetMessage['content']);
      dynamic getContent = messageContent;

      MessageRow messageRow = MessageRow(
        messageId: messageId,
        channelName: decodedGetMessage['channel'].toString(),
        message: Message(
          userId: senderUser.userId,
          channelName: decodedGetMessage['channel'].toString(),
          content: MessageContent(
            cardType: getContent['cardType'].toString(),
            data: getContent['data'].toString(),
            timeStamp: decodedGetMessage['timetoken'].toString(),
          ),
          timetoken: decodedGetMessage['timetoken'].toString(),
        ),
        timeStamp: decodedGetMessage['timetoken'].toString(),
        chatUser: senderUser,
      );

      // ** Save to Isar Message - Users  */
      MessageIsar saveMessage = MessageIsar();
      saveMessage.id = messageRow.messageId;
      saveMessage.channelName = messageRow.channelName;
      saveMessage.messageFromUserId =
          int.parse(messageRow.chatUser.userId.toString());
      saveMessage.message = messageRow.toString();
      saveMessage.timeStamp = int.parse(messageRow.timeStamp.toString());
      messageStore.saveMessage(saveMessage);
    }
  }

  _onUserProfileUpdate(
      UserProfileUpdate event, Emitter<ChannelState> emit) async {
    // upgrade account member to agent
    final getUserDetails = await app_instance.itemApiProvider
        .getUserProfile(event.updatedProfileUserId);
    UserIsar saveUser = UserIsar();
    saveUser.id = int.parse(getUserDetails['id'].toString());
    saveUser.roleTypeId = getUserDetails['role_id'].toString();
    saveUser.username = getUserDetails['displayName'].toString();
    saveUser.userImage = getUserDetails['photo_url'].toString();
    saveUser.publicUpdatedTimeToken = getUserDetails['public_updated'];
    await userStore.saveUser(saveUser);

    if (event.notificationType == "upgradeRequestNotification") {
      emit(state.copyWith(status: ChannelStatus.updating));

      List<ChatChannel> channelLists = state.channelList;
      dynamic channelList = await chatRepo.getChannels(channelId: 1);

      if (channelList != null && channelList.isNotEmpty) {
        if (channelList["channelList"] != "") {
          channelLists.add(channelList["channelList"].first);
          chatRepo
              .subscribeChannel(channelList["channelList"].first.channelName);
          print(
              "***Subscribe for upgradeRequestNotification** ${channelList["channelList"].first.channelName}");
        }
      }

      Fluttertoast.showToast(
        msg: "account_upgrade.lbl_account_upgrade_success".tr(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: greenColor,
        textColor: lightColor,
      );

      await app_instance.utility
          .updateJwtUser({"role_id": getUserDetails['role_id'].toString()});

      emit(state.copyWith(
          channelList: channelLists, status: ChannelStatus.success));
    }
    // update profile info
    if (event.notificationType == "updateProfileNotification" ||
        event.notificationType == "updateUserNotification") {
      if (getUserDetails != null) {
        emit(state.copyWith(status: ChannelStatus.updating));
        dynamic toUsers = state.toUsers;
        if (currentUser!.id.toString() == event.updatedProfileUserId) {
          Map<String, dynamic> userDataForUpdate = {
            "displayName": getUserDetails['displayName'].toString(),
            "image_url": getUserDetails['photo_url'].toString()
          };
          await app_instance.utility.updateJwtUser(userDataForUpdate);
        }

        toUsers.removeWhere(
            (element) => element.userId == event.updatedProfileUserId);

        ChatUser currentUpdatedUser = ChatUser(
            userId: getUserDetails['id'].toString(),
            username: getUserDetails['displayName'].toString(),
            userImage: getUserDetails['photo_url'].toString(),
            roleTypeId: getUserDetails['role_id'].toString());

        toUsers.add(currentUpdatedUser);

        // If channel not present in the list start
        List<ChatChannel> channelLists = state.channelList;
        List<ChatChannel> updatedList = [];
        for (ChatChannel channel in channelLists) {
          if (channel.chatToUser.isNotEmpty &&
              channel.chatToUser.first.userId == event.updatedProfileUserId) {
            channel = channel.copyWith(chatToUser: [currentUpdatedUser]);
          }
          updatedList.add(channel);

          dynamic checkPresence =
              await chatRepo.checkPresence(channel.channelName.toString());

          if (checkPresence.toString() == '0' &&
              (channel.chatFlag == "0" ||
                  channel.chatFlag == "1" ||
                  channel.chatFlag == "3")) {
            await chatRepo.subscribeChannel(channel.channelName.toString());
          }
        }

        emit(state.copyWith(
            channelList: updatedList,
            toUsers: toUsers,
            status: ChannelStatus.success));
      }
    }
  }

  _onChannelIndicator(
      ChannelIndicator event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.updating));
    ChatUser chatUser = await chatRepo.getChatUser(userId: event.userId);

    // 0 = typing ON
    // 1 typing OFF
    if (event.currentSignal == 0) {
      Future.delayed(const Duration(seconds: 10), () {
        add(ChannelIndicator(
          channelName: event.channelName,
          currentSignal: 1,
          userId: event.userId,
        ));
      });
    }

    List<ChatChannel> channelList = state.channelList.map((e) {
      if (e.channelName == event.channelName) {
        if (event.currentSignal <= 1) {
          if (chatUser != ChatUser.empty) {
            return e.copyWith(
              typingIndicator: signalType[event.currentSignal] == 'typingOff'
                  ? ''
                  : chatUser.username,
              typingIndicatorStartTime: signalType[event.currentSignal] ==
                      'typingOff'
                  ? ''
                  : app_instance.utility.getUnixTimeStampInPubNubPrecision(),
            );
          }
        }

        if (event.currentSignal == 4 ||
            event.currentSignal == 5 ||
            event.currentSignal == 6) {
          if (chatUser != ChatUser.empty) {
            return e.copyWith(
              chatFlag: (event.currentSignal == 4 || event.currentSignal == 6)
                  ? "2"
                  : "1",
            );
          }
        }
      }
      return e;
    }).toList();

    emit(state.copyWith(
      channelList: channelList,
      status: ChannelStatus.success,
    ));
  }

  void _onMovedOnChatScreen(
      MovedOnChatScreen event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(
      status: ChannelStatus.movetochat,
      currentActiveChannel: event.currentActiveChannel,
    ));
    if (event.connectionStatus == "ConnectionStatus.connected") {
      _envelopStreamChannelBloc?.pause();
      _chatRepoStreamChannelBloc?.pause();
      _currentUserStreamChannelBloc?.pause();
    }
  }

  _onSetCurrentActiveChannel(
      SetCurrentActiveChannel event, Emitter<ChannelState> emit) {
    emit(state.copyWith(
      currentActiveChannel: event.currentActiveChannel,
      status: ChannelStatus.success,
    ));
  }

  storeUnreadChannelCount() async {
    try {
      dynamic unreadPrivateChannelCount = state.unreadPrivateChannelCount;
      if (unreadPrivateChannelCount == 0) {
        app_instance.userRepository.storeUserLastVisitedTime(
            unreadPrivateChannelCount: unreadPrivateChannelCount.toString());
      }
      await app_instance.storage.write(
          key: 'unreadPrivateChannelCount',
          value: unreadPrivateChannelCount.toString());
    } catch (er, _) {
      await app_instance.storage
          .write(key: 'unreadPrivateChannelCount', value: '10');
    }
  }

  Future<void> _onMovedChannelScreen(
      MovedChannelScreen event, Emitter<ChannelState> emit) async {
    ChatChannel currentActiveChannel = event.chatChannel!;

    List<ChatUser> toUsers = [];
    if (event.toUsers!.isNotEmpty) {
      toUsers = event.toUsers!;
      toUsers = [...toUsers, ...state.toUsers];
    }

    emit(state.copyWith(
      status: ChannelStatus.updating,
      toUsers: [
        ...{...toUsers}
      ],
      currentActiveChannel: ChatChannel.empty,
    ));

    List<ChatChannel> channelList = state.channelList;

    // If channelId greater than 2 then delete channel
    if (int.parse(event.chatChannel!.channelId) > 2) {
      dynamic decodedChannelData =
          jsonDecode(event.chatChannel!.channelData.toString());
      if (decodedChannelData['type'] != "private_chat") {
        if (event.chatChannel!.chatFlag == "4") {
          await channelStore.deleteChannel(
              channelId: int.parse(event.chatChannel!.channelId));
          channelList.removeWhere(
              (element) => element.channelId == currentActiveChannel.channelId);
        }
      }
    }
    // Back from visiting the chat screen

    ChatChannel updatedChannel = ChatChannel.empty;

    channelList = channelList.map((e) {
      if (e.channelName == currentActiveChannel.channelName) {
        updatedChannel = e.copyWith(
          lastMessageRow: currentActiveChannel.lastMessageRow,
          typingIndicator: '',
          lastMessageTime: currentActiveChannel.lastMessageTime,
          unreadMessageCount: '0',
          chatFlag: currentActiveChannel.chatFlag,
          lastVisitTime:
              app_instance.utility.getUnixTimeStampInPubNubPrecision(),
          channelData: currentActiveChannel.channelData,
          chatToUser: currentActiveChannel.chatToUser,
          typingIndicatorStartTime: '',
          lastMessageSentTime: currentActiveChannel.lastMessageSentTime,
          messagesRow: currentActiveChannel.messagesRow,
          disableTypingMessage: currentActiveChannel.disableTypingMessage,
          totalNumberOfMessages: currentActiveChannel.totalNumberOfMessages,

          // increase the count of unread messages
        );
        return updatedChannel;
      }
      return e;
    }).toList();

    channelList.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    emit(state.copyWith(
      channelList: channelList,
      lastVisitedChannel: event.chatChannel,
      status: ChannelStatus.success,
    ));

    await updateLocalStorage(updatedChannel);

    /// Store the last time in local storage send timestamp to server
    if (event.chatChannel!.channelId != '') {
      // save time token
      chatRepo.updateUserTimeStamp(channelId: event.chatChannel!.channelId);
    }
    storeUnreadChannelCount();
    _envelopStreamChannelBloc?.resume();
    _chatRepoStreamChannelBloc?.resume();
    _currentUserStreamChannelBloc?.resume();
  }

  _onResumeEnvelopeStream(
      ResumeEnvelopeStream event, Emitter<ChannelState> emit) async {
    _envelopStreamChannelBloc?.resume();
    _chatRepoStreamChannelBloc?.resume();
    _currentUserStreamChannelBloc?.resume();
  }

  _onChannelMessageReceived(
      ChannelMessageReceived event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(
      status: ChannelStatus.updating,
    ));

    Map<String, dynamic> messageObject = jsonDecode(event.message!.toString());

    dynamic message = messageObject["text"];
    dynamic timetoken = event.timetoken;

    dynamic updateMessage = jsonDecode(message);
    updateMessage['timeStamp'] = event.timetoken;

    message = jsonEncode(updateMessage);

    List<ChatChannel> channelList = state.channelList;

    if (messageObject.containsKey("cardType") == false) {
      // Message received from User
      String senderUserId = event.senderUserId.toString();

      ChatUser senderUser = state.toUsers.firstWhere(
          (element) => element.userId.toString() == senderUserId, orElse: () {
        return ChatUser.empty;
      });

      if (senderUser == ChatUser.empty) {
        senderUser = await chatRepo.getChatUser(userId: senderUserId);
      }

      // If channel not present in the list start
      ChatChannel searchChannel = channelList.firstWhere(
          (element) => element.channelName == event.channelName, orElse: () {
        return ChatChannel.empty;
      });

      bool addMessage = true;

      if (searchChannel == ChatChannel.empty) {
        dynamic getchannelDetails =
            await chatRepo.getChannelDetailsByName(event.channelName);

        if (getchannelDetails != '') {
          Map<dynamic, dynamic> channelDetails = getchannelDetails
              .map((key, value) => MapEntry(key, value?.toString()));

          searchChannel = ChatChannel(
            channelId: channelDetails['id'].toString(),
            channelName: channelDetails['friendlyName'],
            lastMessageRow: MessageRow.empty,
            typingIndicator: '',
            lastMessageTime: timetoken,
            unreadMessageCount: '1',
            chatFlag: channelDetails['chatFlag'].toString(),
            lastVisitTime: '',
            channelData: channelDetails['channelData'].toString(),
            chatUser: chatUser,
            chatToUser: [senderUser],
            typingIndicatorStartTime: '',
            disableTypingMessage: '',
          );
        }
        channelList.add(searchChannel);
      } else {
        if (searchChannel.messagesRow.runtimeType != Null &&
            searchChannel.messagesRow!.isNotEmpty) {
          int checkLastTenOnly = 0;
          for (var element in searchChannel.messagesRow!) {
            checkLastTenOnly++;
            if (element.timeStamp == timetoken) {
              addMessage = false;
            }
            if (checkLastTenOnly > 10) {
              break;
            }
          }
        }
      }
      // If channel not present in the list End
      dynamic decodedMessageText = jsonDecode(message);
      dynamic decodedMessageData = jsonDecode(decodedMessageText['data']);

      if (decodedMessageData["replyToMessageId"] != null) {
        decodedMessageText = await chatRepo.getUpdatedMessageData(
            decodedMessageText, state.toUsers);
      }

      String cardType = decodedMessageText['cardType'];
      decodedMessageText['cardType'] = decodedMessageText['cardType'];

      MessageRow recievedMessageRow = MessageRow(
        messageId: "${senderUser.userId}-${searchChannel.channelId}-$timetoken",
        channelName: event.channelName.toString(),
        chatUser: senderUser,
        message: Message(
          userId: senderUser.userId,
          channelName: event.channelName.toString(),
          content: MessageContent(
            cardType: cardType,
            data: decodedMessageText['data'],
            timeStamp: timetoken.toString(),
          ),
          timetoken: timetoken.toString(),
        ),
        timeStamp: timetoken.toString(),
      );

      ChatChannel updateChannel = ChatChannel.empty;
      channelList = channelList.map((e) {
        if (e.channelName == event.channelName) {
          String unreadMessageCount =
              (int.parse(e.unreadMessageCount) + 1).toString();

          if (state.lastVisitedChannel.lastMessageTime != "" &&
              BigInt.parse(event.timetoken.toString()) ==
                  BigInt.parse(state.lastVisitedChannel.lastMessageTime)) {
            unreadMessageCount = e.unreadMessageCount.toString();
          }

          List<MessageRow> messageList =
              (e.messagesRow.runtimeType == Null || e.messagesRow!.isEmpty)
                  ? []
                  : e.messagesRow!;

          searchChannel = e.copyWith(
            chatToUser: e.chatToUser,
            lastMessageRow: recievedMessageRow,
            messagesRow: (addMessage == true &&
                    messageList.isNotEmpty &&
                    messageList.last.timeStamp != recievedMessageRow.timeStamp)
                ? [...messageList, recievedMessageRow]
                : [...messageList],
            typingIndicator: '',
            lastMessageTime: timetoken.toString(),
            unreadMessageCount: unreadMessageCount,
            totalNumberOfMessages: state.status != ChannelStatus.movetochat
                ? e.totalNumberOfMessages + 1
                : e.totalNumberOfMessages,
            disableTypingMessage: '',
          );
          updateChannel = searchChannel;
          return updateChannel;
        }
        return e;
      }).toList();

      channelList.sort((a, b) {
        if (b.chatFlag == '4') {
          return 1;
        } else {
          return b.lastMessageTime.compareTo(a.lastMessageTime);
        }
      });

      emit(state.copyWith(
        channelList: channelList,
        status: ChannelStatus.success,
      ));
      await updateLocalStorage(updateChannel);
      // Message saved when new message received
      // ** Save to Isar Message - Users  */
      chatRepo.saveMessageRow(recievedMessageRow);
      // ** Save to Isar Message - Users  */
    }
  }

  Future<void> _onDeleteChannel(
      DeleteChannel event, Emitter<ChannelState> emit) async {
    // If channelId greater than 2 then delete channel
    if (event.chatChannel!.channelId != "" &&
        event.chatChannel != ChatChannel.empty &&
        int.parse(event.chatChannel!.channelId.toString()) <= 2) {
      return emit(state.copyWith(status: ChannelStatus.channelDeleted));
    }

    emit(state.copyWith(status: ChannelStatus.channelDeleted));
    List<ChatChannel> channelList = state.channelList;
    try {
      Map<String, Object>? jsonData = {
        'channelId': event.chatChannel!.channelId.toString(),
        'chatFlag': signalType[int.parse('7')],
        'token': currentUser!.token.toString(),
      };

      dynamic decodedChannelData =
          jsonDecode(event.chatChannel!.channelData.toString());

      if (decodedChannelData.runtimeType != Null &&
          decodedChannelData.containsKey('deleted_by') &&
          decodedChannelData['deleted_by'].toString() !=
              currentUser!.id.toString()) {
        await app_instance.chatApiProvider
            .updateChannel(event.chatChannel!.channelId.toString(), jsonData);
      }

      channelList.removeWhere(
          (element) => element.channelId == event.chatChannel!.channelId);

      await channelStore.deleteChannel(
          channelId: int.parse(event.chatChannel!.channelId));

      channelList.removeWhere(
          (element) => element.channelId == event.chatChannel!.channelId);

      return emit(state.copyWith(
          status: ChannelStatus.updated, channelList: channelList));
    } catch (ex, trace) {
      print(ex);
      print(trace);
    }
  }

  _onNewRequestCreated(
      NewRequestCreated event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.newRequestCreated));
    List<ChatChannel> channelList = state.channelList;

    List<int> deleteChannelIdList = [];
    channelList.removeWhere((element) {
      dynamic decodedChannelData = jsonDecode(element.channelData!);
      if (decodedChannelData['type'] == 'private_chat') {
        return false;
      } else {
        String ownerUserId = decodedChannelData['chat_user']['0'].toString();
        if (ownerUserId.toString() == chatUser.userId.toString()) {
          deleteChannelIdList.add(int.parse(element.channelId));
          return true;
        }
        return ownerUserId.toString() == chatUser.userId.toString();
      }
    });

    emit(state.copyWith(
        channelList: [...channelList], status: ChannelStatus.success));

    for (var element in deleteChannelIdList) {
      // If channelId greater than 2 then delete channel
      if (element > 2) {
        await channelStore.deleteChannel(channelId: element);
      }
    }
  }

  Future<void> _onUpdateChannelList(
      UpdateChannelList event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.updating));

    if (event.reversed == false) {
      emit(state.copyWith(
          channelList: [...event.channelList!], status: ChannelStatus.success));
    } else {
      emit(state.copyWith(
          channelList: [...event.channelList!.reversed],
          status: ChannelStatus.success));
    }
  }

  Future<void> _onNewChannelInitiate(
      NewChannelInitiate event, Emitter<ChannelState> emit) async {
    try {
      emit(state.copyWith(
        status: ChannelStatus.newChannelInitiate,
      ));
      List<ChatChannel> channelList = state.channelList;
      List<int> deleteChannelList = [];

      // Remove if existing channel of the user available only request type
      channelList.removeWhere((item) {
        if (int.parse(item.channelId) < 2) return false;

        dynamic decodedChannelData = jsonDecode(item.channelData!);
        bool isCurrentUserRequest = false;
        if (decodedChannelData['type'] == 'private_chat') return false;
        try {
          if (decodedChannelData['chat_user'] != null &&
              decodedChannelData['type'] == "request_prop") {
            String ownerUserId =
                decodedChannelData['chat_user']['0'].toString();
            if (ownerUserId == chatUser.userId) {
              isCurrentUserRequest = true;
            }
          }
        } catch (e) {
          print('e: $e');
        }

        if (isCurrentUserRequest == false) {
          if (item.chatToUser.isNotEmpty &&
              item.chatToUser.first.userId == event.userId) {
            deleteChannelList.add(int.parse(item.channelId));
          }
          return item.chatToUser.isNotEmpty &&
              item.chatToUser.first.userId == event.userId;
        } else {
          return false;
        }
      });
      // Remove if existing channel of the user available only request type

      Map<String, dynamic> message = jsonDecode(event.message!);

      String userId = event.userId.toString();
      ChatUser chatToUser = ChatUser.empty;
      chatToUser = await chatRepo.getChatUser(userId: userId);

      dynamic getChannelId;
      if (message['text'].runtimeType != String) {
        getChannelId = message['text'];
      } else {
        getChannelId = jsonDecode(message['text']);
      }

      dynamic getChannelData = getChannelId['data'];
      dynamic jsobData = jsonDecode(getChannelData);
      String newCardType = jsobData["newCardType"];
      String firstMessage =
          jsobData.containsKey("firstMessage") ? jsobData["firstMessage"] : "";

      dynamic channel =
          await chatRepo.getChannelDetailsById(jsobData["channelId"]);

      if (channel != null) {
        try {
          channel["channel"];
        } catch (e, _) {
          print('${jsobData["channelId"]} request id not found');
        }

        Map<dynamic, dynamic> chatChannel = channel["channel"]
            .map((key, value) => MapEntry(key, value?.toString()));

        String channelName = chatChannel["friendlyName"];
        String channelId = chatChannel["id"];
        try {
          if (chatRepo.channelList.contains(channelName.toString()) == false) {
            await chatRepo.subscribeChannel(channelName.toString());
            print("***Subcribed to New Channel** $channelName");
          }
        } catch (e, stackTrace) {
          print('''e: $e \n stackTrace: $stackTrace''');
        }

        // String timeStamp = chatChannel["id"];
        bool channelIfExist = false;

        for (int i = 0; i < channelList.length; i++) {
          if (channelList[i].channelName.toString() == channelName.toString()) {
            channelIfExist = true;
          }
        }

        if (channelIfExist == false) {
          Map<String, String> singleMessage = {
            "text": "chat_section.lbl_chat_initiated".tr(),
            "channelId": channelId.toString()
          };

          String lastMessageTime =
              app_instance.utility.getUnixTimeStampInPubNubPrecision();

          Message newMessageInitiated = Message(
            userId: chatUser.userId,
            channelName: channelName,
            timetoken: lastMessageTime,
            content: MessageContent(
              cardType: newCardType,
              data: jsonEncode(singleMessage),
              timeStamp: lastMessageTime,
            ),
          );

          MessageRow messageRow = MessageRow(
            messageId: "${chatUser.userId}-$channelId-$lastMessageTime",
            channelName: channelName,
            message: newMessageInitiated,
            chatUser: chatUser,
            timeStamp: lastMessageTime,
          );

          ChatChannel newChannel = ChatChannel(
              channelName: channelName.toString(),
              lastMessageRow: messageRow,
              lastMessageTime: lastMessageTime,
              chatUser: chatUser,
              chatToUser: [chatToUser],
              channelId: channelId.toString(),
              unreadMessageCount: '1',
              chatFlag: chatChannel['chatFlag'].toString(),
              channelData: chatChannel['channelData'].toString());

          channelList = [
            ...[newChannel],
            ...channelList,
          ];

          await updateLocalStorage(newChannel);

          emit(state.copyWith(
            channelList: [...channelList],
            status: ChannelStatus.success,
          ));

          for (var element in deleteChannelList) {
            // If channelId greater than 2 then delete channel
            if (element > 2) {
              await channelStore.deleteChannel(channelId: element);
            }
          }

          // ** Save to Message to Isar  */
          if (firstMessage.length > 5) {
            // First message as Request from Requested User.
            dynamic getFirstMessage = jsonDecode(firstMessage);
            String messageId =
                "${chatUser.userId}-$channelId-${getFirstMessage['timetoken']}";
            MessageRow firstMessgeToSave = MessageRow(
              messageId: messageId,
              channelName: channelName,
              message: Message(
                channelName: channelName,
                userId: chatUser.userId,
                timetoken: getFirstMessage['timetoken'],
                content: MessageContent.fromJson(
                  getFirstMessage['content'],
                ),
              ),
              chatUser: chatUser,
              timeStamp: getFirstMessage['timetoken'],
            );

            MessageIsar saveMessage = MessageIsar();
            saveMessage.id = firstMessgeToSave.messageId;
            saveMessage.channelName = firstMessgeToSave.channelName;
            saveMessage.messageFromUserId =
                int.parse(firstMessgeToSave.chatUser.userId.toString());
            saveMessage.message = firstMessgeToSave.toString();
            saveMessage.timeStamp =
                int.parse(firstMessgeToSave.timeStamp.toString());
            await messageStore.saveMessage(saveMessage);
          }
          // ** Save to Message to Isar  */

          // channelList
          //     .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
        }
      }
    } catch (exeption, stackTrace) {
      print('''e: $exeption \n stackTrace: $stackTrace''');
    }
  }

  Future<void> _resetState(
      ChannelResetState event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(
      status: ChannelStatus.initial,
      hasReachedMax: false,
      typingIndicator: '',
      currentActiveChannel: ChatChannel.empty,
      serverChannelList: [],
      channelList: [],
      channelLastSyncTime: '',
    ));
  }

  _onPrivateSubscribe(PrivateSubscribe event, Emitter<ChannelState> emit) {
    List<ChatChannel> currentChannelList = state.channelList;
    ChatChannel channelFound = currentChannelList.firstWhere(
        (element) => element.channelId == event.newChannel.channelId,
        orElse: () => ChatChannel.empty);

    if (channelFound == ChatChannel.empty) {
      print("Added into ChannelList ${event.newChannel.chatFlag}");
      currentChannelList.add(event.newChannel);
    } else {
      print("updating chat Flat ${event.newChannel.chatFlag}");
      ChatChannel updateChannel = ChatChannel.empty;
      currentChannelList = currentChannelList.map((e) {
        if (e.channelName == event.newChannel.channelName) {
          ChatChannel searchChannel =
              e.copyWith(chatFlag: event.newChannel.chatFlag);
          updateChannel = searchChannel;
          return updateChannel;
        }
        return e;
      }).toList();
    }

    currentChannelList.sort((a, b) {
      if (b.chatFlag == '4') {
        return 1;
      } else {
        return b.lastMessageTime.compareTo(a.lastMessageTime);
      }
    });

    emit(state.copyWith(
      channelList: currentChannelList,
      status: ChannelStatus.updated,
    ));
  }

  // 1st step get channel from LocalStorage
  Future<void> _onFetchFromStore(
      FetchFromStore event, Emitter<ChannelState> emit) async {
    // _envelopStreamChannelBloc?.pause();
    // _chatRepoStreamChannelBloc?.pause();
    // _currentUserStreamChannelBloc?.pause();

    if (event.status == ChannelStatus.initial) {
      String channelLastSyncTime = '';
      dynamic getchannelLastSyncTime =
          await appConfigStore.fetchConfig(configName: 'channelLastSyncTime');
      if (getchannelLastSyncTime.runtimeType != Null) {
        channelLastSyncTime = getchannelLastSyncTime.toString();
      } else {
        // Fill the storage once
        // print("++++++++++++++++++++++++++++++++++++++");
        await app_instance.storeChannel.getChannelChatStore();
        // getchannelLastSyncTime =
        //     await appConfigStore.fetchConfig(configName: 'channelLastSyncTime');
        // channelLastSyncTime = getchannelLastSyncTime.toString();
        // print("++++++++++++++++++++++++++++++++++++++");
      }

      emit(state.copyWith(
        lastVisitedChannel: ChatChannel.empty,
        hasReachedMax: false,
        channelList: [],
        serverChannelList: [],
        channelLastSyncTime: channelLastSyncTime,
      ));
    }

    try {
      int channelCount = await channelStore.countChannel();
      if (channelCount == 0) {
        emit(state.copyWith(totalChannelAtLocal: 0));
        return add(const ChannelSync(status: ChannelStatus.serverSyncStarted));
      }
      if (state.hasReachedMax == true) {
        return add(const ChannelSync(status: ChannelStatus.serverSyncStarted));
      }

      if (kDebugMode) {
        print(
            "Trip ${state.channelList.length / 10}  ${state.channelList.length}");
      }

      List<ChatChannel> chatChannel = [];
      dynamic savedChannels = await channelStore.fetchSavedChannel(
          limit: 10, offset: state.channelList.length);

      for (int i = 0; i < savedChannels.length; i++) {
        ChannelIsar channelIsar = savedChannels[i];

        List<ChatUser> chatToUsers = [];
        for (var element in channelIsar.chatToUserId) {
          ChatUser chatToUserList =
              await chatRepo.getChatUser(userId: element.toString());
          chatToUsers.add(chatToUserList);
        }

        ChatUser chatUserToStore = await chatRepo.getChatUser(
            userId: channelIsar.chatUserId.toString());

        dynamic storedLocalChannel = ChatChannel(
          channelId: channelIsar.id.toString(),
          channelName: channelIsar.channelName,
          lastMessageRow: channelIsar.lastMessageRow.isNotEmpty
              ? MessageRow.fromJson(
                  jsonDecode(channelIsar.lastMessageRow.toString()))
              : MessageRow.empty,
          lastMessageTime: channelIsar.lastMessageTime.toString(),
          lastMessageSentTime: channelIsar.lastMessageSentTime.toString(),
          unreadMessageCount: channelIsar.unreadMessageCount.toString(),
          chatFlag: channelIsar.chatFlag.toString(),
          chatToUser: chatToUsers,
          chatUser: chatUserToStore,
          channelData: channelIsar.channelData.toString(),
          typingIndicator: channelIsar.typingIndicator.toString(),
        );

        if (app_instance.utility.validateOwnerShip(storedLocalChannel) ==
            true) {
          chatChannel.add(storedLocalChannel);
        }
      }

      chatChannel
          .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

      chatChannel = [
        ...state.channelList,
        ...chatChannel,
      ];

      emit(state.copyWith(
        channelList: chatChannel,
        status: ChannelStatus.success,
        hasReachedMax: chatChannel.length >= channelCount ? true : false,
      ));

      if (kDebugMode) {
        print(
            "Local channel Count $channelCount Length of ChannelList ${chatChannel.length} ${state.hasReachedMax}");
        print("Event lastSyncTimeStamp  ${event.lastSyncTimeStamp}");
      }

      if (state.hasReachedMax == false) {
        return add(
            const FetchFromStore(status: ChannelStatus.localSyncInprogress));
      } else {
        emit(state.copyWith(
            totalChannelAtLocal: state.channelList.length,
            hasReachedMax: false));

        return add(const ChannelSync(
          status: ChannelStatus.serverSyncStarted,
        ));
      }
    } catch (e, stacktrace) {
      print('''Error: $e \n StackTrace: $stacktrace Initial Failed ''');
      emit(state.copyWith(status: ChannelStatus.failure));
    }
  }

  // 2nd step afer local SyncEnd we need to sync with Server
  _onChannelSync(ChannelSync event, Emitter<ChannelState> emit) async {
    if (kDebugMode) {
      print('***channel Sync started***  ${state.hasReachedMax}');
    }
    List<ChatChannel> serverChannelList = [];
    List<ChatUser> toUsers = [];

    if (state.hasReachedMax == true) return;

    if (event.status == ChannelStatus.serverSyncStarted) {
      emit(state.copyWith(hasReachedMax: false, serverChannelList: []));
    }

    try {
      if (state.hasReachedMax == false) {
        int startIndex = (state.serverChannelList.isNotEmpty)
            ? ((state.serverChannelList.length) / 10).round() + 1
            : 1;

        dynamic toUserWithChannels = await chatRepo.getChannels(
          startIndex: startIndex,
          lastVisitedChannel: state.lastVisitedChannel,
          channelLastSyncTime: state.channelLastSyncTime,
        );

        int totalChannel = 0;
        if (toUserWithChannels != null) {
          serverChannelList = toUserWithChannels["channelList"];
          toUsers = toUserWithChannels["toUsersList"];
          totalChannel = toUserWithChannels["channelCount"];
          emit(state.copyWith(totalChannelAtServer: totalChannel));

          if (totalChannel == 0) {
            return emit(
              state.copyWith(
                channelLastSyncTime:
                    app_instance.utility.getUnixTimeStampInPubNubPrecision(),
                hasReachedMax: true,
                status: ChannelStatus.serverSyncEnd,
              ),
            );
          }
        }

        // delete channels from local and state.
        List deletedChannelsList = [];
        if (toUserWithChannels != null) {
          String deletedChannels = toUserWithChannels["deleteChannels"];
          deletedChannelsList = deletedChannels.split(',');
        }
        List<ChatChannel> updatedChannelList = state.channelList;

        // remove channels
        if (deletedChannelsList.isNotEmpty) {
          for (var deletedChannelId in deletedChannelsList) {
            // remove channel from isar local db
            for (var element in updatedChannelList) {
              if (element.channelId == deletedChannelId) {
                channelStore.deleteChannel(
                    channelId: int.parse(deletedChannelId));
              }
            }
            // remove channel from state
            state.channelList.removeWhere(
                (element) => element.channelId == deletedChannelId);
          }
        }

        serverChannelList = [...serverChannelList, ...state.serverChannelList];

        // update the channel list with the updated data from server
        List<ChatChannel> storeChannelList = state.channelList;

        for (int i = 0; i < serverChannelList.length; i++) {
          ChatChannel channel = serverChannelList[i];
          ChatChannel channelFound = storeChannelList.firstWhere(
              (element) => element.channelId == channel.channelId,
              orElse: () => ChatChannel.empty);

          if (channelFound == ChatChannel.empty) {
            storeChannelList.add(channel);
          } else {
            storeChannelList = storeChannelList.map((e) {
              if (e.channelId == channel.channelId) {
                return channel;
              }
              return e;
            }).toList();
          }
          // Message saved when channel updated
          // app_instance.storeChannel.storeSingleMessage(chatRepo, channel);
        }

        if (kDebugMode) {
          print("udpate local storage");
          print(state.channelList.length);
          print("udpate local storage");
        }

        storeChannelList
            .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

        emit(state.copyWith(
          serverChannelList: serverChannelList,
          channelList: storeChannelList,
          toUsers: toUsers,
          hasReachedMax:
              serverChannelList.length >= totalChannel ? true : false,
        ));

        print(
            "storeChannelList ${state.toString()} \n ServerTotalChannel ${totalChannel} \n TotalServerChannelInState  ${state.totalChannelAtServer}");

        if (state.hasReachedMax == false) {
          if (kDebugMode) {
            print(
                '***serverSyncInprogress LSyncT*** ${state.channelLastSyncTime}');
          }
          return add(
            const ChannelSync(
              status: ChannelStatus.serverSyncInprogress,
            ),
          );
        } else {
          int channelCount = await channelStore.countChannel();
          if (channelCount < state.totalChannelAtServer) {
            await app_instance.appConfigStore.saveAppConfig(AppConfigIsar()
              ..configName = "channelLastSyncTime"
              ..configValue = '');

            emit(state.copyWith(
              channelLastSyncTime: '',
              channelList: [],
            ));
            return add(
              const FetchFromStore(status: ChannelStatus.initial),
            );
          }

          if (kDebugMode) {
            print('***channel serverSyncEnd***');
            print('***Total Channel $totalChannel***');
            print(
                '***Server channel List ${state.serverChannelList.length}***');
            print('***Local updated List  ${state.channelList.length}***');
            print('***channel serverSyncEnd***');
          }

          emit(
            state.copyWith(
              channelLastSyncTime:
                  app_instance.utility.getUnixTimeStampInPubNubPrecision(),
              status: ChannelStatus.serverSyncEnd,
            ),
          );

          dynamic lastUserUpdatedTimeToken =
              await userStore.fetchLastUpdatedUser();

          if (lastUserUpdatedTimeToken != 0) {
            await app_instance.itemApiProvider
                .getUpdatedUsers(lastUserUpdatedTimeToken)
                .then((updatedUsers) async {
              if (updatedUsers.runtimeType == Null) return;
              dynamic userDataList = updatedUsers['data'];
              for (dynamic updatedUser in userDataList) {
                UserIsar saveUser = UserIsar();
                saveUser.id = int.parse(updatedUser['id'].toString());
                saveUser.roleTypeId = updatedUser['role_id'].toString();
                saveUser.username = updatedUser['displayName'].toString();
                saveUser.userImage = updatedUser['photo_url'].toString();
                saveUser.publicUpdatedTimeToken = updatedUser['public_updated'];
                await userStore.saveUser(saveUser);
              }
            });
          }

          await app_instance.appConfigStore.saveAppConfig(AppConfigIsar()
            ..configName = "channelLastSyncTime"
            ..configValue =
                app_instance.utility.getUnixTimeStampInPubNubPrecision());
        }
      }
    } catch (e, stacktrace) {
      print('''Error: $e \n StackTrace: $stacktrace Initial Failed ''');
      emit(state.copyWith(status: ChannelStatus.failure));
    }
  }

  _onUserSignalSent(UserSignalSent event, Emitter<ChannelState> emit) async {
    String signalTypeValue = signalType[int.parse(event.signalType.toString())];

    if (event.currentChannel.runtimeType != ChatChannel &&
        signalTypeValue == "profileUpdate") {
      // uI = userId, sT = signalType

      Map<String, Object>? jsonData = {
        'uI': currentUser!.id.toString(),
        'sT': event.signalType,
      };
      chatRepo.sendChatSignal(event.currentChannel, jsonEncode(jsonData));
    }
  }

  updateLocalStorage(ChatChannel currentChannel) async {
    if (currentChannel.channelName == "") return;
    channel_store.Channel channelStore = channel_store.Channel();
    message_store.MessageRow messageStore = message_store.MessageRow();
    // ** Save to Isar Channel - Users - First Message */
    ChannelIsar saveChannel = ChannelIsar();
    List<int> chatToUsers = [];
    if (int.parse(currentChannel.channelId) > 2) {
      for (var element in currentChannel.chatToUser) {
        try {
          if (element.userId != 'null') {
            chatToUsers.add(int.parse(element.userId.toString()));
          }
        } catch (err) {
          print(chatUser.toString());
          print("cahnnel bloc error is ------- $err");
          print("channel bloc $currentChannel");
        }
      }
    }

    bool saveFlag = false;
    saveFlag = app_instance.utility.validateOwnerShip(currentChannel);
    if (saveFlag == true) {
      saveChannel.id = int.parse(currentChannel.channelId.toString());
      saveChannel.channelName = currentChannel.channelName;
      saveChannel.lastMessageRow = currentChannel.lastMessageRow.toString();
      saveChannel.lastMessageTime = int.parse(currentChannel.lastMessageTime);
      saveChannel.unreadMessageCount = currentChannel.unreadMessageCount;
      saveChannel.chatFlag = currentChannel.chatFlag;
      saveChannel.chatToUserId = chatToUsers;
      saveChannel.chatUserId =
          int.parse(currentChannel.chatUser.userId.toString());
      saveChannel.channelData = currentChannel.channelData;
      saveChannel.typingIndicator = currentChannel.typingIndicator;
      saveChannel.typingIndicatorStartTime =
          currentChannel.typingIndicatorStartTime;
      saveChannel.lastVisitTime = int.parse(currentChannel.lastMessageTime);
      saveChannel.lastMessageSentTime =
          int.parse(currentChannel.lastMessageSentTime.toString());
      saveChannel.totalNumberOfMessages = currentChannel.totalNumberOfMessages;
      await channelStore.saveChannel(saveChannel);
    } else {
      await channelStore.deleteChannel(
          channelId: int.parse(currentChannel.channelId));
      messageStore.deleteMessageByChannelName(currentChannel.channelName);
    }
    // ** Save to Isar Channel - Users - First Message */
  }
}

@override
Stream<ChannelState> transformEvents(events, next) {
  return events.switchMap(next);
}
