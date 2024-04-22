import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/isar/request/request_isar.dart';
import 'package:anytimeworkout/module/request/model/request_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pubnub/pubnub.dart';
import '../../../../config/constant.dart';
import '../../../../model/user_model.dart';
import '../../../../repository/item_api_provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/isar/app_config/app_config.dart' as app_config_store;
import 'package:anytimeworkout/isar/request/request_row.dart' as request_store;
import 'package:anytimeworkout/config.dart' as app_instance;

part 'my_request_event.dart';
part 'my_request_state.dart';

class MyRequestBloc extends Bloc<MyRequestEvent, MyRequestState> {
  late UserModel? currentUser;
  int updateRequestCount = 0;

  app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();
  request_store.RequestRow requestStore = request_store.RequestRow();
  StreamSubscription<Envelope>? _envelopStreamChannelBloc;

  MyRequestBloc({required currentUserBloc})
      : currentUser = currentUserBloc.state.currentUser,
        super(const MyRequestState()) {
    on<RequestDelete>(_onDeleteRequest);
    on<MyRequestResetState>(_resetState);
    on<MyRequestFetched>(_onMyRequestFetched);
    on<UpdateUserRequest>(_onUpdateUserRequest);
    on<AddNewRequest>(_onAddNewRequest);
    // on<SyncToServer>(_onSyncToServer);

    Constants.refreshMyRequestScreen.stream.listen((event) {
      add(MyRequestFetched(status: state.status!));
    });

    _envelopStreamChannelBloc =
        currentUserBloc.appEnvelopStream.stream.listen((envelope) {
      // Removed If condition to sync the multiple devices
      // print("***********Debug**********");
      // print("${envelope.messageType} MessageType");
      // print("${envelope.channel} ChannelName");
      // print("${envelope.timetoken} TimeToken");
      // print("${envelope.uuid} -- UserId");
      // // print("${chatUser.userId.toString()} currentUserID");
      // print("${envelope.content} Content");
      // print("***********Debug**********");
      envelopEvents(envelope);
    });
  }

  // envelope events for update request
  envelopEvents(envelope) {
    switch (envelope.messageType) {
      case MessageType.normal:
        dynamic notificationAndCard =
            getCardTypeWithRequestNotification(envelope);
        if (notificationAndCard['cardType'] == 'requestNotification') {
          dynamic decodedMessageFormat = jsonDecode(
              notificationAndCard['messageFormatForEvent'].toString());
          dynamic notificationText = decodedMessageFormat['text'];
          dynamic decodedData = jsonDecode(notificationText['data']);
          try {
            if (!isClosed) {
              add(
                UpdateUserRequest(
                    updateType: decodedData['newCardType'],
                    createdAt:
                        int.parse(decodedData['createdTimetoken'].toString()),
                    updatedAt: int.parse(decodedData['updatedTimetoken']),
                    serverId: decodedData['requestId'].toString()),
              );
            }
          } catch (er, _) {
            print("error is=======$er stack is ==========$_");
          }
        }
    }
  }

  // update request function
  _onUpdateUserRequest(
      UpdateUserRequest event, Emitter<MyRequestState> emit) async {
    if (state.status != MyRequestStatus.success) return;
    String? userId = currentUser!.id.toString();

    emit(state.copyWith(status: MyRequestStatus.updateRequest));
    List<RequestModel> itemMyRequestList = state.itemMyRequest!;
    List<RequestModel> updatedList = [];
    request_store.RequestRow requestStore = request_store.RequestRow();
    if (event.updateType == "newRequest") {
      // for insert only updating the server id
      String requestId = "$userId${event.createdAt}";
      for (var element in itemMyRequestList) {
        if (element.createdTimetoken == event.createdAt) {
          updatedList.add(element.copyWith(id: int.parse(event.serverId)));
        } else {
          updatedList.add(element);
        }
      }
      await requestStore.updateRequestIdOnly(
          event.createdAt, event.updatedAt, event.serverId, requestId);
    }
    if (event.updateType == "updateRequest") {
      updateRequestCount++;
      if (updateRequestCount <= 1) {
        Fluttertoast.showToast(
          msg: 'request.lbl_activated_request_admin'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      dynamic getUpdatedRequestData =
          await app_instance.itemApiProvider.getRequestDetails(event.serverId);
      RequestIsar saveRequest = RequestIsar();
      saveRequest.id = "$userId${getUpdatedRequestData['created_timetoken']}";
      saveRequest.serverId = getUpdatedRequestData['id'].toString();
      saveRequest.descriptionAr =
          getUpdatedRequestData['description_ar'].toString();
      saveRequest.descriptionEn =
          getUpdatedRequestData['description_en'].toString();
      saveRequest.location = getUpdatedRequestData['location'].toString();
      saveRequest.budget = getUpdatedRequestData['budget'].toString();
      saveRequest.phone = getUpdatedRequestData['phone'].toString();
      saveRequest.status = getUpdatedRequestData['status']!;
      saveRequest.createdAt = getUpdatedRequestData['created_timetoken']!;
      saveRequest.updatedAt = getUpdatedRequestData['updated_timetoken']!;
      await requestStore.saveRequest(saveRequest);

      for (var element in itemMyRequestList) {
        if (element.createdTimetoken == event.createdAt) {
          // remove from state
          updatedList.add(RequestModel(
              id: int.parse(getUpdatedRequestData['id'].toString()),
              descriptionAr: getUpdatedRequestData['description_ar'],
              descriptionEn: getUpdatedRequestData['description_en'],
              location: getUpdatedRequestData['location'].toString(),
              budget: getUpdatedRequestData['budget'].toString(),
              phone: getUpdatedRequestData['phone'].toString(),
              agencyNameAr: "",
              agencyNameEn: "",
              channelExist: 0,
              channelId: "",
              contactType: 0,
              email: "",
              friendlyName: "",
              isDeleted: 0,
              photoUrl: "",
              status: getUpdatedRequestData['status'],
              userId: int.parse(userId.toString()),
              userName: "",
              createdTimetoken: getUpdatedRequestData['created_timetoken'],
              updatedTimetoken: getUpdatedRequestData['updated_timetoken']));
        } else {
          updatedList.add(element);
        }
      }
    }
    emit(state.copyWith(
        status: MyRequestStatus.success, itemMyRequest: updatedList));
  }

  dynamic getCardTypeWithRequestNotification(envelopeContent) {
    dynamic messageFormatForEvent;
    dynamic cardType = "";
    dynamic sendCardTypeWithMessage;

    if (envelopeContent.content.runtimeType.toString() == "List<dynamic>") {
      messageFormatForEvent = envelopeContent.content.first;
      dynamic messageData = jsonDecode(messageFormatForEvent);
      cardType = messageData['text'];
    } else {
      messageFormatForEvent = envelopeContent.content;
      if (envelopeContent.messageType == MessageType.normal) {
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

  _onAddNewRequest(AddNewRequest event, Emitter<MyRequestState> emit) {
    emit(state.copyWith(status: event.status));
  }

  // Delete Requests
  _onDeleteRequest(RequestDelete event, Emitter<MyRequestState> emit) async {
    emit(state.copyWith(status: MyRequestStatus.loading));
    dynamic userId = currentUser!.id.toString();
    List<RequestModel>? itemMyRequestList = [];

    String requestId =
        "${event.requestDetails.userId}${event.requestDetails.createdTimetoken}";

    int? requsetServerId = event.requestDetails.id;

    try {
      Map<String, String> jsonData = {
        'token': currentUser!.token.toString(),
        'id': requsetServerId.toString(),
        'user_id': userId
      };
      await requestStore.requestDeleteById(requestId);

      itemMyRequestList = state.itemMyRequest;

      itemMyRequestList!
          .removeWhere((element) => element.id == event.requestDetails.id);
      int myRequestTotalCount = await requestStore.getTotalLength();
      emit(state.copyWith(
          status: MyRequestStatus.success,
          itemMyRequest: itemMyRequestList,
          myRequestCount: myRequestTotalCount.toString()));
      await app_instance.itemApiProvider.deleteRequest(jsonData);
    } catch (ex, trace) {
      print(ex);
      print(trace);
    }
  }

  // Fetched -------------
  _onMyRequestFetched(
      MyRequestFetched event, Emitter<MyRequestState> emit) async {
    if (state.hasReachedMaxRequest == true ||
        state.status == MyRequestStatus.localSyncLoading) return;
    RequestIsar saveRequest = RequestIsar();

    String? userId = currentUser!.id.toString();
    int lastRequestTime;
    if (state.status == MyRequestStatus.initial) {
      // await _onSyncToServer();
      lastRequestTime = int.parse(app_instance.utility
          .getUnixTimeStampInPubNubPrecision(getFutureTime: true));
    } else {
      lastRequestTime = (state.itemMyRequest!.isNotEmpty)
          ? int.parse(state.itemMyRequest!.last.updatedTimetoken.toString())
          : int.parse(app_instance.utility
              .getUnixTimeStampInPubNubPrecision(getFutureTime: true));
    }
    dynamic myRequestCount = await requestStore.getTotalLength();
    emit(state.copyWith(
        status: MyRequestStatus.localSyncLoading,
        myRequestCount: myRequestCount.toString()));

    dynamic localRequestData;
    List<RequestModel> requestList = [];

    // featch request from locally
    localRequestData = await requestStore.fetchSavedRequestsOrderByTimeDesc(
        updatedTime: lastRequestTime);

    int pageNumber = state.itemMyRequest!.isNotEmpty
        ? (state.itemMyRequest!.length / 15).round()
        : 1;

    if (localRequestData.isEmpty) {
      Map<String, String> jsonData = {
        'token': currentUser!.token.toString(),
        'getRequestLastSyncTime': lastRequestTime.toString(),
        'newRequests': 'false'
      };

      await app_instance.itemApiProvider
          .myRequestList(jsonData)
          .then((results) async {
        for (dynamic result in results) {
          saveRequest.id = "$userId${result.createdTimetoken!}";
          saveRequest.serverId = result.id.toString();
          saveRequest.descriptionAr = result.descriptionAr.toString();
          saveRequest.descriptionEn = result.descriptionEn.toString();
          saveRequest.location = result.location.toString();
          saveRequest.budget = result.budget.toString();
          saveRequest.phone = result.phone.toString();
          saveRequest.status = result.status!;
          saveRequest.createdAt = result.createdTimetoken!;
          saveRequest.updatedAt = result.updatedTimetoken!;
          await requestStore.saveRequest(saveRequest);
        }
      });
      localRequestData = await requestStore.fetchSavedRequestsOrderByTimeDesc(
          updatedTime: lastRequestTime);
    }
    // if server data or local data is empty MAX reached
    if (localRequestData.isEmpty) {
      // Local DATA Empty
      emit(state.copyWith(
          status: MyRequestStatus.success,
          hasReachedMaxRequest: true,
          myRequestCount: myRequestCount.toString()));
      return;
    } else {
      localRequestData.forEach((element) {
        if (element != null) {
          requestList.add(RequestModel(
              id: int.parse(element.serverId.toString()),
              descriptionAr: element.descriptionAr,
              descriptionEn: element.descriptionEn,
              location: element.location,
              budget: element.budget,
              phone: element.phone,
              agencyNameAr: "",
              agencyNameEn: "",
              channelExist: 0,
              channelId: "",
              contactType: 0,
              email: "",
              friendlyName: "",
              isDeleted: 0,
              photoUrl: "",
              status: element.status,
              userId: int.parse(userId.toString()),
              userName: "",
              createdTimetoken: element.createdAt,
              updatedTimetoken: element.updatedAt));
        }
      });
    }
    // update record if server id 0
    Future.delayed(const Duration(milliseconds: 500), () {
      requestStore.fetchWithServerIdZero().then((results) async {
        for (dynamic element in results) {
          dynamic getRequestData = await app_instance.itemApiProvider
              .getRequestDetailsByCreatedTimeToken(element.createdAt);
          saveRequest.id = "$userId${getRequestData['created_timetoken']}";
          saveRequest.serverId = getRequestData['id'].toString();
          saveRequest.descriptionAr =
              getRequestData['description_ar'].toString();
          saveRequest.descriptionEn =
              getRequestData['description_en'].toString();
          saveRequest.location = getRequestData['location'].toString();
          saveRequest.budget = getRequestData['budget'].toString();
          saveRequest.phone = getRequestData['phone'].toString();
          saveRequest.status =
              (getRequestData['status'] != null) ? getRequestData['status'] : 0;
          saveRequest.createdAt = getRequestData['created_timetoken']!;
          saveRequest.updatedAt = getRequestData['updated_timetoken']!;
          await requestStore.saveRequest(saveRequest);
        }
      });
    });
    myRequestCount = await requestStore.getTotalLength();
    emit(state.copyWith(
        status: MyRequestStatus.success,
        itemMyRequest: [...state.itemMyRequest!, ...requestList],
        page: pageNumber,
        hasReachedMaxRequest: (localRequestData.length < 15) ? true : false,
        myRequestCount: myRequestCount.toString()));
    return;
  }

  _onSyncToServer() async {
    dynamic getLastUpdatedRequestTimeToken =
        await requestStore.fetchLastUpdatedRequest();
    if (getLastUpdatedRequestTimeToken == 0) return;
    String? userId = currentUser!.id.toString();
    int lastRequestTime = int.parse(getLastUpdatedRequestTimeToken.toString());

    Map<String, String> jsonData = {
      'token': currentUser!.token.toString(),
      'getRequestLastSyncTime': lastRequestTime.toString(),
      'newRequests': 'true'
    };
    RequestIsar saveRequest = RequestIsar();
    await app_instance.itemApiProvider
        .myRequestList(jsonData)
        .then((results) async {
      for (dynamic result in results) {
        saveRequest.id = "$userId${result.createdTimetoken!}";
        saveRequest.serverId = result.id.toString();
        saveRequest.descriptionAr = result.descriptionAr.toString();
        saveRequest.descriptionEn = result.descriptionEn.toString();
        saveRequest.location = result.location.toString();
        saveRequest.budget = result.budget.toString();
        saveRequest.phone = result.phone.toString();
        saveRequest.status = result.status!;
        saveRequest.createdAt = result.createdTimetoken!;
        saveRequest.updatedAt = result.updatedTimetoken!;
        await requestStore.saveRequest(saveRequest);
      }
    });
  }

  Future<void> _resetState(
      MyRequestResetState event, Emitter<MyRequestState> emit) async {
    emit(state.copyWith(status: MyRequestStatus.initial));
  }
}
