import 'dart:convert';
import 'dart:developer';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/config/chat_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pubnub/pubnub.dart';
import '../../../repository/item_api_provider.dart';
import '../model/chat_model.dart';
import 'package:http/http.dart' as http;

/// Isar Packages
import 'package:anytimeworkout/isar/channel/channel_isar.dart';
import 'package:anytimeworkout/isar/user/user_isar.dart';
import 'package:anytimeworkout/isar/message/message_isar.dart';

import 'package:anytimeworkout/isar/channel/channel.dart' as channel_store;
import 'package:anytimeworkout/isar/user/user.dart' as user_store;
import 'package:anytimeworkout/isar/message/message_row.dart' as message_store;
import 'package:anytimeworkout/config.dart' as app_instance;

/// Isar Packages

import 'pub_nub_repo.dart';

class ChatRepo extends PubNubInstance {
  channel_store.Channel channelStore = channel_store.Channel();
  user_store.User userStore = user_store.User();
  message_store.MessageRow messageStore = message_store.MessageRow();

  late UserModel? currentUser;

  ChatRepo({this.currentUser}) : super(currentUser);

  Future<dynamic> deleteChannel({required String channelId}) async {
    return app_instance.chatApiProvider.deleteChannel(channelId);
  }

  String getPubnubServerTime() {
    dynamic pubNubServerTime = getPServerTime();
    return pubNubServerTime.toString();
  }

  Future<String> getPServerTime() async {
    dynamic pubNubServerTime = await getPubNubServerTime();
    return pubNubServerTime.toString();
  }

  // Flag Status Details
  // -1 - Taken for public channels,
  // 0 - channel not created,
  // 1 - created at pubnub,
  // 2 - chat ended by one of the user,
  // 3 - chat ended by both user,
  // 4 - channel deactivate
  // 5 - agent not responded to the request.
  // 6 - deleted by admin.
  // 7 - block channel.
  // Do not send the channel created by logged in user and chat_flg 0.

  Future<dynamic> getChannels({
    int startIndex = 1,
    ChatChannel? lastVisitedChannel,
    channelLastSyncTime = '',
    channelId = Null,
  }) async {
    // Keep this comment for future reference
    // dynamic pubNubServerTime = await getPubNubServerTime();
    UserModel currentUser = await app_instance.utility.jwtUser();

    List<ChatChannel> channels = [];
    Set<ChatUser> toUsers = {};

    ChatUser chatUser = ChatUser(
      userId: currentUser.id.toString(),
      username: currentUser.name.toString(),
      userImage: currentUser.profileImage.toString(),
      roleTypeId: currentUser.roleId.toString(),
    );

    try {
      int channelCount;
      List<ChatUser> toUserList = [];

      dynamic channelList;
      if (channelId == Null) {
        channelList = await app_instance.itemApiProvider.getChannelList(
            pageNumber: startIndex, channelLastSyncTime: channelLastSyncTime);
      } else {
        channelList = await getChannelDetailsById(channelId);
        channelList["channels"] = [channelList["channel"]];
      }

      if (channelList.containsKey('channels') &&
          channelList["channels"].length > 0) {
        dynamic publicChannelLastVisit = channelList['publicChannelLastVisit'];
        for (int i = 0; i < channelList["channels"].length; i++) {
          if ((channelList["channels"][i]['chatFlag'].toString() == '0') &&
              currentUser.id.toString() !=
                  channelList["channels"][i]['toUserId'].toString()) {
            continue;
          }
          dynamic decodedLastData =
              jsonDecode(channelList["channels"][i]['channelData']);
          String chatCount = '0';
          String? lastVisitTime = "15880563460000000";

          if (channelList["channels"][i]['id'] > 2 &&
              lastVisitTime == "15880563460000000") {
            if (decodedLastData['last_visit'] != null) {
              dynamic getLastVisitData = decodedLastData['last_visit'];
              if (getLastVisitData != null) {
                if (getLastVisitData[currentUser.id.toString()] != null) {
                  lastVisitTime =
                      "${getLastVisitData[currentUser.id.toString()]['timestamp']}";
                }
              }
            }
          } else {
            if (publicChannelLastVisit != null &&
                publicChannelLastVisit.isNotEmpty) {
              if (publicChannelLastVisit
                  .containsKey("${channelList["channels"][i]['id']}")) {
                lastVisitTime = publicChannelLastVisit[
                        "${channelList["channels"][i]['id']}"]
                    .toString();
              } else {
                lastVisitTime = "15880563460000000";
              }
            }
          }

          if (lastVisitedChannel.runtimeType != Null &&
              lastVisitedChannel!.channelId.toString() ==
                  channelList["channels"][i]['id'].toString()) {
            chatCount = '0';
          } else {
            try {
              if (channelList["channels"][i]['chatFlag'] == 0 &&
                  lastVisitTime == "15880563460000000") {
                chatCount = '1';
              } else {
                chatCount = await getUnreadCount(
                  channel: channelList["channels"][i]['friendlyName'],
                  currentUserId: currentUser.id.toString(),
                  lastVisitTime: lastVisitTime,
                );
              }
            } catch (e) {
              log("${channelList["channels"][i]['friendlyName']} exception line 113");
            }
          }

          ChatUser chatToUser = ChatUser.empty;
          int chatToUserPublicUpdated = 0;

          if (channelList["channels"][i]['toUserId'] == currentUser.id) {
            dynamic senderInfo =
                jsonDecode(channelList["channels"][i]['sender_info']);
            chatToUserPublicUpdated = senderInfo['public_updated'];
            chatToUser = ChatUser(
              userId: "${senderInfo['sender_id']}",
              username: "${senderInfo['sender_name']}" == 'null'
                  ? 'user-${senderInfo['sender_id']}'
                  : "${senderInfo['sender_name']}",
              userImage: senderInfo['sender_photo'].toString(),
              roleTypeId: "${senderInfo['senderRoleId']}",
            );
          } else {
            if (channelList["channels"][i]['receiver_info'].runtimeType !=
                Null) {
              dynamic receiverInfo =
                  jsonDecode(channelList["channels"][i]['receiver_info']);
              chatToUserPublicUpdated = receiverInfo['public_updated'];
              chatToUser = ChatUser(
                userId: "${receiverInfo['receiver_id']}",
                username: "${receiverInfo['receiver_name']}" == 'null'
                    ? 'user-${receiverInfo['receiver_id']}'
                    : "${receiverInfo['receiver_name']}",
                userImage: receiverInfo['receiver_photo'].toString(),
                roleTypeId: "${receiverInfo['receiverRoleId']}",
              );
            }
          }

          Map<String, dynamic> getLastMessage;
          if (channelId == Null) {
            getLastMessage = jsonDecode(
                channelList["channels"][i]['last_message'].toString());
          } else {
            getLastMessage =
                jsonDecode(channelList["channels"][i]['lastMsg'].toString());
          }

          // MessageId Format:  '${state.currentUser.userId}-${currentChannel.channelId}-$messageSentTime';
          String messageId =
              "${getLastMessage['uuid']}-${channelList["channels"][i]['id']}-${getLastMessage['timetoken']}}";

          // Last Message From

          ChatUser lastMessageUser = toUserList.firstWhere(
              (element) => element.userId == getLastMessage['uuid'],
              orElse: () => ChatUser.empty);

          if (lastMessageUser == ChatUser.empty) {
            lastMessageUser = await getChatUser(userId: getLastMessage['uuid']);

            toUserList.contains(lastMessageUser) == false
                ? toUserList.add(lastMessageUser)
                : null;
          }

          dynamic getContent = jsonDecode(getLastMessage['content'].toString());

          Message lastMessage = Message(
            userId: chatUser.userId,
            channelName: channelList["channels"][i]['friendlyName'],
            timetoken: getLastMessage['timetoken'],
            content: MessageContent(
              cardType: getContent['cardType'],
              data: getContent['data'],
              timeStamp: getLastMessage['timetoken'],
            ),
          );

          MessageRow lastMessageRow = MessageRow(
            messageId: messageId,
            channelName: channelList["channels"][i]['friendlyName'],
            message: lastMessage,
            chatUser: lastMessageUser,
            timeStamp: getLastMessage['timetoken'],
          );

          String currentUserLastMessageSentTime =
              await channelStore.fetchLastMessageSentTime(
                  channelId:
                      int.parse(channelList["channels"][i]['id'].toString()));

          channels.add(ChatChannel(
            channelId: "${channelList["channels"][i]['id']}",
            channelName: channelList["channels"][i]['friendlyName'],
            lastMessageRow: lastMessageRow,
            lastMessageTime: lastMessageRow.timeStamp.toString(),
            unreadMessageCount: chatCount,
            chatFlag: channelList["channels"][i]['chatFlag'].toString(),
            chatToUser: [chatToUser],
            chatUser: chatUser,
            channelData: channelList['channels'][i]['channelData'],
            typingIndicator: '',
            lastMessageSentTime: currentUserLastMessageSentTime,
            totalNumberOfMessages: channelList['channels'][i]['chatCount'],
          ));
          toUsers.add(chatToUser);

          // ** Save to Isar Channel - Users */
          ChannelIsar saveChannel = ChannelIsar();
          saveChannel.id = int.parse("${channelList["channels"][i]['id']}");
          saveChannel.channelName =
              "${channelList["channels"][i]['friendlyName']}";
          saveChannel.lastMessageRow = lastMessageRow.toString();
          saveChannel.lastMessageTime = int.parse(lastMessageRow.timeStamp);
          saveChannel.unreadMessageCount = chatCount;
          saveChannel.chatFlag =
              channelList["channels"][i]['chatFlag'].toString();
          saveChannel.chatToUserId = [int.parse(chatToUser.userId)];
          saveChannel.chatUserId = int.parse(chatUser.userId);
          saveChannel.channelData = channelList['channels'][i]['channelData'];
          saveChannel.typingIndicator = '';
          saveChannel.typingIndicatorStartTime = '';
          saveChannel.lastVisitTime = int.parse(lastVisitTime.toString());
          saveChannel.lastMessageSentTime =
              int.parse(currentUserLastMessageSentTime);
          saveChannel.totalNumberOfMessages =
              channelList['channels'][i]['chatCount'];
          await channelStore.saveChannel(saveChannel);

          if (chatToUser != ChatUser.empty) {
            UserIsar saveUser = UserIsar();
            saveUser.id = int.parse(chatToUser.userId);
            saveUser.roleTypeId = chatToUser.roleTypeId;
            saveUser.username = chatToUser.username;
            saveUser.userImage = chatToUser.userImage;
            saveUser.publicUpdatedTimeToken = chatToUserPublicUpdated;
            await userStore.saveUser(saveUser);
          }
          // ** Save to Isar Channel - Users  */
        }
      }

      channelCount = (channelId == Null) ? channelList["channelCount"] : 1;
      toUserList = toUsers.toList();
      String deleteChannels = channelList.containsKey('deleteChannels')
          ? channelList["deleteChannels"]
          : "";

      dynamic toUserWithChannels = {
        "channelCount": channelCount,
        "deleteChannels": deleteChannels,
        "toUsersList": toUserList,
        "channelList": channels,
      };
      return toUserWithChannels;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
    }
  }

  Future<dynamic> getStoredChatHistory(
      ChatChannel chatChannel, String timeStamp, List<ChatUser> toUsers,
      [String storedLastMessageTime = '0']) async {
    Map<String, dynamic> sendBack = {
      "chatHistory": [],
      "toUsers": [],
    };

    if (storedLastMessageTime == '0') {
      storedLastMessageTime = app_instance.utility
          .getUnixTimeStampInPubNubPrecision(
              date: DateTime.now()
                  .add(const Duration(days: 1))
                  .toUtc()
                  .toString());
    }

    List<MessageRow> chatHistory = [];
    List<MessageIsar> storedMessageCollection = await messageStore
        .fetchSavedMessage(chatChannel.channelName, int.parse(timeStamp));

    if (storedMessageCollection.isNotEmpty &&
        BigInt.parse(storedLastMessageTime.toString()) >=
            BigInt.parse(chatChannel.lastMessageTime.toString())) {
      if (kDebugMode) {
        print("****From LocalStorage**** ${storedMessageCollection.length}");
      }
      int j = storedMessageCollection.length;
      for (int i = 0; i < storedMessageCollection.length; i++) {
        j--;

        MessageIsar messageIsar = storedMessageCollection[j];

        // Convert isar Message to MessageRow
        ChatUser chatFromUser =
            await getChatUser(userId: messageIsar.messageFromUserId.toString());
        dynamic getIsarMessage = jsonDecode(messageIsar.message);
        dynamic getMessage = getIsarMessage['message'];
        dynamic getContent = getMessage['content'];

        MessageRow messageRow = MessageRow(
          messageId: messageIsar.id.toString(),
          channelName: messageIsar.channelName,
          message: Message(
            userId: chatFromUser.userId,
            channelName: messageIsar.channelName,
            content: MessageContent(
              cardType: getContent['cardType'].toString(),
              data: getContent['data'].toString(),
              timeStamp: getContent['timeStamp'].toString(),
            ),
            timetoken: getMessage['timetoken'].toString(),
          ),
          timeStamp: getMessage['timetoken'].toString(),
          chatUser: chatFromUser,
        );
        // Convert isar Message to MessageRow

        chatHistory.add(messageRow);

        ChatUser chatUser = toUsers.firstWhere(
            (element) => element.userId == chatFromUser.userId,
            orElse: () => ChatUser.empty);

        if (chatUser.isEmpty) {
          ChatUser addChatUser = await getChatUser(
              userId: messageIsar.messageFromUserId.toString());
          toUsers.add(addChatUser);
        }
      }
      int maximumMessageLimit =
          int.parse(dotenv.env['MESSAGE_PER_PAGE'].toString());
      if (chatHistory.length < maximumMessageLimit) {
        dynamic sendFromServer = await getMessageFromServer(
            chatChannel: chatChannel, timeStamp: chatHistory.first.timeStamp);
        chatHistory = [...chatHistory, ...sendFromServer["chatHistory"]];
        toUsers = [...toUsers, ...sendFromServer["toUsers"]];
      }

      return sendBack = {
        "chatHistory": chatHistory,
        "toUsers": toUsers,
      };
    } else {
      sendBack = await getMessageFromServer(
          chatChannel: chatChannel, timeStamp: timeStamp);
      return sendBack;
    }
  }

  // Get message from local storage
  Future<dynamic> getMessageFromLocalStorage({
    required ChatChannel chatChannel,
    String timeStamp = '',
  }) async {
    Map<String, dynamic> sendBack = {
      "chatHistory": [],
      "toUsers": [],
    };

    List<MessageRow> chatHistory = [];
    List<MessageIsar> storedMessageCollection = await messageStore
        .fetchSavedMessage(chatChannel.channelName, int.parse(timeStamp));
    if (kDebugMode) {
      print("****From LocalStorage**** ${storedMessageCollection.length}");
    }
    int j = storedMessageCollection.length;
    for (int i = 0; i < storedMessageCollection.length; i++) {
      j--;

      MessageIsar messageIsar = storedMessageCollection[j];

      // Convert isar Message to MessageRow
      ChatUser chatFromUser =
          await getChatUser(userId: messageIsar.messageFromUserId.toString());
      dynamic getIsarMessage = jsonDecode(messageIsar.message);
      dynamic getMessage = getIsarMessage['message'];
      dynamic getContent = getMessage['content'];

      MessageRow messageRow = MessageRow(
        messageId: messageIsar.id.toString(),
        channelName: messageIsar.channelName,
        message: Message(
          userId: chatFromUser.userId,
          channelName: messageIsar.channelName,
          content: MessageContent(
            cardType: getContent['cardType'].toString(),
            data: getContent['data'].toString(),
            timeStamp: getContent['timeStamp'].toString(),
          ),
          timetoken: getMessage['timetoken'].toString(),
        ),
        timeStamp: getMessage['timetoken'].toString(),
        chatUser: chatFromUser,
      );
      // Convert isar Message to MessageRow

      chatHistory.add(messageRow);
    }

    return sendBack = {
      "chatHistory": chatHistory,
    };
  }

  // Get User first check the store and then live db
  Future<ChatUser> getChatUser({required String userId}) async {
    if (userId == '0') return ChatUser.empty;
    ChatUser chatUser = ChatUser.empty;
    UserIsar? userIsar =
        await userStore.getUserbyId(int.parse(userId.toString()));

    if (userIsar.runtimeType == Null) {
      try {
        final getUserDetails = await app_instance.itemApiProvider
            .getUserProfile(userId.toString());
        chatUser = ChatUser(
          userId: getUserDetails["id"].toString(),
          username: getUserDetails["displayName"].toString(),
          userImage: getUserDetails["photo_url"] ?? '',
          roleTypeId: getUserDetails["role_id"].toString(),
        );
        try {
          if (chatUser.userId != "null" && chatUser.username != "null") {
            UserIsar saveUser = UserIsar();
            saveUser.id = int.parse(chatUser.userId);
            saveUser.roleTypeId = chatUser.roleTypeId;
            saveUser.username = chatUser.username;
            saveUser.userImage = chatUser.userImage;
            saveUser.publicUpdatedTimeToken = getUserDetails['public_updated'];
            await userStore.saveUser(saveUser);
          }
        } catch (e) {
          print("Function getChatUser  $userId");
          print(chatUser.toString());
          print(e);
        }
      } catch (e, stacktrace) {
        if (kDebugMode) {
          print('Exception occurred: $e stackTrace: $stacktrace');
        }
      }
    } else {
      chatUser = ChatUser(
        userId: userIsar!.id.toString(),
        username: userIsar.username.toString(),
        userImage: userIsar.userImage.toString(),
        roleTypeId: userIsar.roleTypeId.toString(),
      );
    }
    return chatUser;
  }

  // Get message from Server and save to local storage
  Future<dynamic> getMessageFromServer({
    required ChatChannel chatChannel,
    String timeStamp = '',
    getNewMessages = false,
  }) async {
    Map<String, dynamic> sendBack = {
      "chatHistory": [],
      "toUsers": [],
    };
    List<MessageRow> chatHistory = [];
    List<ChatUser> toUsers = [];
    dynamic getHistory;

    if (getNewMessages == true) {
      getHistory = await app_instance.chatApiProvider
          .getNewMessages(chatChannel, timeStamp);
    } else {
      getHistory = await app_instance.chatApiProvider
          .getStoredChatHistory(chatChannel, timeStamp);
    }

    if (kDebugMode) {
      print("****From Database**** ${getHistory.length}");
    }

    if (getHistory.isNotEmpty) {
      int j = getHistory.length;
      for (int i = 0; i < getHistory.length; i++) {
        j--;
        dynamic messageData;

        if (getHistory[j]['message'].runtimeType == String) {
          messageData = json.decode(getHistory[j]['message']);
        } else {
          messageData = getHistory[j]['message'];
        }

        dynamic messageStatus = getHistory[j]['status'];
        ChatUser chatUser = await getChatUser(userId: messageData['uuid']);
        String messageId =
            "${chatUser.userId}-${chatChannel.channelId}-${getHistory[j]['timetoken']}";
        if (messageStatus == 0) {
          messageId =
              "${chatUser.userId}-${chatChannel.channelId}-${messageData['timetoken']}";
          await messageStore.deleteMessageByMessageId(messageId);
        } else {
          dynamic getContent = jsonDecode(messageData['content']);

          MessageRow messageRow = MessageRow(
            messageId: messageId,
            channelName: messageData['channel'].toString(),
            message: Message(
              userId: chatUser.userId,
              channelName: messageData['channel'].toString(),
              content: MessageContent(
                cardType: getContent['cardType'].toString(),
                data: getContent['data'].toString(),
                timeStamp: getHistory[j]['timetoken'].toString(),
              ),
              timetoken: getHistory[j]['timetoken'].toString(),
            ),
            timeStamp: getHistory[j]['timetoken'].toString(),
            chatUser: chatUser,
          );

          // ** Save to Isar Message - Users  */
          saveMessageRow(messageRow);
          // ** Save to Isar Message - Users  */

          toUsers.add(chatUser);
          chatHistory.add(messageRow);
        }
      }
      return sendBack = {
        "chatHistory": chatHistory,
        "toUsers": toUsers,
      };
    }
    return sendBack;
  }

  dynamic saveMessageRow(MessageRow messageRow) async {
    MessageIsar saveMessage = MessageIsar();
    saveMessage.id = messageRow.messageId;
    saveMessage.channelName = messageRow.channelName;
    saveMessage.messageFromUserId =
        (messageRow.chatUser.userId.toString() != "null")
            ? int.parse(messageRow.chatUser.userId.toString())
            : 0;
    saveMessage.message = messageRow.toString();
    saveMessage.timeStamp = int.parse(messageRow.timeStamp.toString());
    messageStore.saveMessage(saveMessage);
  }

  dynamic getUpdatedMessageData(
      dynamic messageObject, List<ChatUser> toUsers) async {
    // call api for get parent message
    dynamic messageData = jsonDecode(messageObject['data']);

    dynamic getParentMessage =
        await getMessageForReply(messageData['replyToMessageId']);

    dynamic parentMessageRow = jsonDecode(getParentMessage['message']);
    MessageContent parentMessageContent =
        MessageContent.fromJson(jsonDecode(parentMessageRow['content']));

    ChatUser messageFromUser = toUsers.firstWhere(
        (element) => element.userId == parentMessageRow['uuid'],
        orElse: () => ChatUser.empty);

    if (messageFromUser == ChatUser.empty) {
      messageFromUser = await getChatUser(userId: parentMessageRow['uuid']);
    }

    MessageRow updatedMessage = MessageRow(
      messageId: parentMessageRow['id'].toString(),
      channelName: parentMessageRow['channel'],
      message: Message(
        userId: messageFromUser.userId,
        channelName: parentMessageRow['channel'],
        content: parentMessageContent,
        timetoken: parentMessageRow['timetoken'],
      ),
      timeStamp: parentMessageRow['timetoken'],
      chatUser: messageFromUser,
    );
    messageData["replyTo"] = updatedMessage.toString();
    dynamic updatedMessageTemp = {
      "cardType": messageObject["cardType"].toString(),
      "data": jsonEncode(messageData),
      "timeStamp": parentMessageRow['timetoken']
    };
    return updatedMessageTemp;
  }

  dynamic createChannel(
      {required String from,
      required String to,
      required String friendlyName,
      required String propertyRequestId}) async {
    Map<String, Object> jsonData = {};
    jsonData = {
      "fromUserId": from,
      "toUserId": to,
      "friendlyName": friendlyName,
      "requestId": propertyRequestId,
      "token": currentUser!.token.toString()
    };
    return app_instance.chatApiProvider.sendChannelData(jsonData);
  }

  dynamic updateUserTimeStamp({required String channelId}) async {
    dynamic lastVisitTime =
        app_instance.utility.getUnixTimeStampInPubNubPrecision();
    Map<String, Object> jsonData = {};
    String? token = currentUser!.token;
    jsonData = {
      "channelId": channelId,
      "lastVisitTime": lastVisitTime.toString(),
      "token": token.toString()
    };
    app_instance.chatApiProvider.updateUserTimeStamp(jsonData);
  }

  Future<dynamic> getSubscribedChannelList() async {
    Map<String, Object> jsonData = {
      'token': currentUser!.token.toString(),
    };
    dynamic getSubscribedChannelList =
        await app_instance.chatApiProvider.getSubscribedChannelApi(jsonData);

    return getSubscribedChannelList;
  }

  Future<dynamic> getChannelDetailsById($channelId) async {
    Map<String, Object> jsonData = {
      'token': currentUser!.token.toString(),
    };
    dynamic getChannelDetails = await app_instance.chatApiProvider
        .getChannelDetailsByIdApi($channelId, jsonData);

    return getChannelDetails;
  }

  Future<dynamic> getChannelDetailsByName($channelName) async {
    dynamic getChannelDetails = await app_instance.chatApiProvider
        .getChannelDetailsByName($channelName);

    return getChannelDetails;
  }

  Future<dynamic> endChat(String channelName) async {
    Map<String, Object> jsonData = {
      'token': currentUser!.token!.toString(),
      'friendlyName': channelName,
    };
    return app_instance.chatApiProvider.endChat(jsonData);
  }

  // Temp name;
  Future<void> endSubscription() async {
    await cancelSubscription();
    return;
  }

  void updateMediaMessage(ChatChannel chatChannel, String notifyUrl,
      String message, String timetoken) async {
    Map<String, dynamic> chatHistory = {
      'uuid': chatChannel.chatUser.userId.toString(),
      'content': message.toString(),
      'timetoken': timetoken,
      'channel': chatChannel.channelName.toString()
    };

    Map<String, Object>? jsonData = {
      'notifyUrl': notifyUrl,
      'token': currentUser!.token.toString(),
      'message': jsonEncode(chatHistory),
      'channelId': chatChannel.channelId.toString(),
      'timetoken': timetoken,
    };
    app_instance.chatApiProvider.updateChatMessage(notifyUrl, jsonData);
  }

  subscribeChatChannel(ChatChannel currentChannel) {
    subscribeChannel(currentChannel.channelName);
  }

  Future<dynamic> sendChatSignal(dynamic currentChannel, String message) async {
    if (currentChannel.runtimeType == ChatChannel) {
      ChatChannel chatChannel = currentChannel; // current channel
      Map<String, String> signalMessage = {
        'signalType': message.toString(),
      };
      sendSignal(chatChannel.channelName, jsonEncode(signalMessage));

      if (int.parse(message) > 1) {
        Map<String, Object>? jsonData = {
          'channelId': chatChannel.channelId.toString(),
          'chatFlag': signalType[int.parse(message)],
          'token': currentUser!.token.toString(),
        };

        dynamic result = await app_instance.chatApiProvider
            .updateChannel(chatChannel.channelId, jsonData);
        return result;
      }
    } else {
      // sending profile update to the public and self channel.
      sendSignal(currentChannel, message);
    }
  }

  Future<dynamic> permitMessaging(ChatChannel chatChannel) async {
    Map<String, Object> jsonData = {
      'token': currentUser!.token.toString(),
    };
    return app_instance.chatApiProvider
        .permitMessaging(jsonData, chatChannel.channelId);
  }

  Future<String> sendChatMessage(
    ChatChannel chatChannel,
    MessageRow messageRow, {
    bool storeInDB = true,
    String messageId = '',
    bool replyTo = false,
    int totalNumberOfMessages = 0,
  }) async {
    Message message = messageRow.message;
    MessageContent messageContent = message.content!;
    dynamic getReplyContent = jsonDecode(messageContent.data);

    getReplyContent.remove('replyTo');
    MessageContent updatedNewMessage =
        (replyTo == true && getReplyContent['replyToMessageId'] != null)
            ? MessageContent(
                cardType: messageContent.cardType,
                data: jsonEncode(getReplyContent),
                timeStamp: messageContent.timeStamp)
            : messageContent;

    PublishResult result = await sendMessage(
        chatChannel.channelName, jsonEncode(updatedNewMessage));
    dynamic messagePublishTimeToken = result.timetoken.toString();

    messageContent = messageContent.copyWith(
      timeStamp: messagePublishTimeToken,
    );

    // ** Save to Isar Message - Users  */
    MessageIsar saveMessage = MessageIsar();
    saveMessage.channelName = chatChannel.channelName;
    // messageId userId-channelId-timeToken
    if (messageId.length > 10) {
      saveMessage.id = messageId;
      messagePublishTimeToken = messageId.split("-").last;
    } else {
      saveMessage.id =
          "${chatChannel.chatUser.userId}-${chatChannel.channelId}-$messagePublishTimeToken";
    }
    messageRow = messageRow.copyWith(
      messageId: saveMessage.id.toString(),
      channelName: chatChannel.channelName,
      message: Message(
        channelName: chatChannel.channelName,
        content: messageContent,
        timetoken: messagePublishTimeToken,
        userId: chatChannel.chatUser.userId,
      ),
      chatUser: messageRow.chatUser,
      timeStamp: messagePublishTimeToken,
    );

    saveMessage.id = messageRow.messageId;
    saveMessage.channelName = messageRow.channelName;
    saveMessage.messageFromUserId =
        int.parse(messageRow.chatUser.userId.toString());
    saveMessage.message = messageRow.toString();
    saveMessage.timeStamp = int.parse(messageRow.timeStamp.toString());
    messageStore.saveMessage(saveMessage);
    // ** Save to Isar Message - Users  */

    if (storeInDB == true) {
      Map<String, dynamic> chatHistory = {
        'uuid': chatChannel.chatUser.userId.toString(),
        'content': jsonEncode(messageContent),
        'timetoken': messagePublishTimeToken,
        'channel': chatChannel.channelName.toString()
      };
      Map<String, Object>? jsonData = {
        'chatFlag': chatChannel.chatFlag.toString(),
        'token': currentUser!.token.toString(),
        'message': jsonEncode(chatHistory),
        'channelId': chatChannel.channelId.toString(),
        'timetoken': messagePublishTimeToken,
      };

      dynamic decodedChannelData =
          jsonDecode(chatChannel.channelData.toString());
      if ((int.parse(chatChannel.channelId) > 2 &&
          decodedChannelData['type'] == "request_prop" &&
          totalNumberOfMessages < 2 &&
          chatChannel.lastMessageRow != MessageRow.empty &&
          (chatChannel.lastMessageRow.message.content!.cardType.toString() ==
                  "newPropertyRequest" ||
              chatChannel.lastMessageRow.message.content!.cardType.toString() ==
                  "firstMessage" ||
              chatChannel.lastMessageRow.message.content!.cardType.toString() ==
                  "mediaPlaceholder"))) {
        jsonData = {
          'chatFlag': chatChannel.chatFlag.toString(),
          'token': currentUser!.token.toString(),
          'message': jsonEncode(chatHistory),
          'channelId': chatChannel.channelId.toString(),
          'timetoken': messagePublishTimeToken,
          'agentInitiated': 'true'
        };
      }
      try {
        app_instance.chatApiProvider.sendChatHistory(jsonData);
      } catch (err, stackTrace) {
        if (kDebugMode) {
          print('''Error $err \n stackTrace $stackTrace''');
        }
      }
    }
    return result.timetoken.toString();
  }

  dynamic checkPresence(String channelName) async {
    if (channelName.isEmpty) {
      return 0;
    }
    final result = await checkNumberOfPresence(channelName);
    return result;
  }

  // Get Pubnub ChatData Just for Reference
  getChatHistory(ChatChannel channel,
      [String start = '', int count = 15]) async {
    List<BatchHistoryResultEntry> customMessageObject = [];

    String sendStart;
    (start.isEmpty)
        ? sendStart = app_instance.utility.getUnixTimeStampInPubNubPrecision()
        : sendStart = start;

    customMessageObject =
        await getHistory(channel.channelName, sendStart, count);

    if (customMessageObject.isEmpty) {
      customMessageObject =
          await getStoredChatHistory(channel, sendStart, [ChatUser.empty]);
    }
    return customMessageObject;
  }

  getMessageForReply(String messageKey) async {
    return await app_instance.chatApiProvider.getMessage(messageKey);
  }

  dynamic iframlyContent(String url) async {
    String iframlyApiUrl =
        "https://iframe.ly/api/iframely?iframe=1&url=$url&api_key=${dotenv.env['IFRAMELYAPIKEY']}";
    return await http.get(Uri.parse(iframlyApiUrl));
  }

  validateImage(String imageUrl) async {
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImage(data['content-type']);
  }

  bool checkIfImage(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }
}
