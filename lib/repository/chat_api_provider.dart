import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/config.dart' as app_instance;
import 'package:anytimeworkout/model/user_model.dart';

import '../module/chat/model/chat_model.dart';
import 'repository.dart';

class ChatApiProvider extends Repository {
  Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
  dynamic recList, rec;
  String? recString;

  updateUserTimeStamp(jsonData) {
    return requestPOST(path: 'channel-last-visit', parameters: jsonData);
  }

  Future<dynamic> sendChannelData(jsonData) async {
    return await requestPOST(path: 'create_channel', parameters: jsonData);
  }

  // Not used this api
  Future<dynamic> endChat(jsonData) async {
    final result =
        await requestPOST(path: 'deactivate-channel', parameters: jsonData);
    return result;
  }

  // update chat flag get updated channel as a response :
  Future<dynamic> updateChannel(String channelId, jsonData) async {
    final result = await requestPOST(
        path: 'update-channel/$channelId', parameters: jsonData);
    return result;
  }

  Future<dynamic> sendChatHistory(jsonData) async {
    final result =
        await requestPOST(path: 'insert-chat-message', parameters: jsonData);
    return result;
  }

  Future<dynamic> updateChatMessage(notifyUrl, jsonData) async {
    final result = await requestPOST(
        path: 'update-chat-message/$notifyUrl', parameters: jsonData);
    return result;
  }

  // Store history local storage
  Future<dynamic> getNewMessages(ChatChannel channel,
      [String start = '', String end = '', int count = 15]) async {
    UserModel currentUser = await app_instance.utility.jwtUser();

    Map<String, Object>? jsonData = {
      'token': currentUser.token.toString(),
      'timetoken': start,
      'newMessages': "true",
      'numberOfMessages': count.toString()
    };
    final result = await requestGET(
        path: "get-channel-history/${channel.channelId}", parameters: jsonData);
    return result;
  }

  Future<dynamic> getStoredChatHistory(ChatChannel channel,
      [String start = '', String end = '', int count = 15]) async {
    UserModel currentUser = await app_instance.utility.jwtUser();

    Map<String, Object>? jsonData = {
      'token': currentUser.token.toString(),
      'timetoken': start,
      'numberOfMessages': count.toString()
    };
    final result = await requestGET(
        path: "get-channel-history/${channel.channelId}", parameters: jsonData);
    return result;
  }

  Future<dynamic> permitMessaging(jsonData, channelId) async {
    var result;
    try {
      result = await requestGET(
          path: 'permit-messaging/$channelId', parameters: jsonData);
    } on SocketException {
      throw Error();
    }
    return result;
  }

  Future<dynamic> getSubscribedChannelApi(jsonData) async {
    final result =
        await requestGET(path: 'active-channels-list', parameters: jsonData);
    return result;
  }

  // get channel details by id
  Future<dynamic> getChannelDetailsByIdApi(id, jsonData) async {
    final result = await requestGET(
        path: 'channel-details-by-id/$id', parameters: jsonData);
    return result;
  }

  // get channel details by name
  Future<dynamic> getChannelDetailsByName(channelName) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {
      'token': currentUser.token!.toString(),
    };
    final result = await requestGET(
        path: 'get-channel-details-by-name/$channelName', parameters: jsonData);
    return result;
  }

  Future deleteChannel(String channelId) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, String> jsonData = {
      'token': currentUser.token.toString(),
    };
    final result = await requestGET(
        path: 'delete-channel/$channelId', parameters: jsonData);
    return result;
  }

  // get message by (userId-channelId-timeToken)
  Future<dynamic> getMessage(String messageKey) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, String> jsonData = {
      'token': currentUser.token.toString(),
      'replyToMessageKey': messageKey
    };
    final apiResponse =
        await requestPOST(path: "get-message-by-key", parameters: jsonData);
    return apiResponse;
  }
}
