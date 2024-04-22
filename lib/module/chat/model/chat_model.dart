import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

class ChatUser {
  // To DO : Add publicUpdated time

  final String userId, username, userImage, roleTypeId;
  const ChatUser(
      {required this.userId,
      required this.username,
      required this.userImage,
      required this.roleTypeId});

  ChatUser.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        username = json['username'],
        userImage = json['userImage'],
        roleTypeId = json['roleTypeId'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'userImage': userImage,
        'roleTypeId': roleTypeId,
      };

  static const empty =
      ChatUser(userId: '0', roleTypeId: '', userImage: '', username: '-----');

  bool get isEmpty => this == ChatUser.empty;

  ChatUser.fromNetworkJson(Map<String, dynamic> json)
      : userId = "${json['userId']}",
        username = json['fullName'],
        userImage = json['userBio.imageName'],
        roleTypeId = "${json['userBio.roleTypeId']}";

  @override
  String toString() {
    // Must need in the following formate if you want to convert string to json and json to string.
    return '{"userId": "$userId", "username": "$username", "userImage": "$userImage", "roleTypeId": "$roleTypeId"}';
  }
}

class MessageContent {
  final String? cardType;
  final dynamic data;
  final String? timeStamp;

  static const empty = MessageContent(
    cardType: '',
    data: '',
    timeStamp: '',
  );

  const MessageContent({
    this.cardType,
    this.data,
    this.timeStamp,
  });

  MessageContent copyWith({
    String? cardType,
    dynamic data,
    String? timeStamp,
  }) {
    MessageContent chatCardBack = MessageContent(
      cardType: cardType ?? this.cardType,
      data: data ?? this.data,
      timeStamp: timeStamp ?? this.timeStamp,
    );
    return chatCardBack;
  }

  String getCard() => cardType.toString();

  MessageRow getReplyMessage() {
    dynamic messageText;
    MessageRow messageRowReply = MessageRow.empty;
    try {
      messageText = jsonDecode(data);
    } catch (e) {
      messageText = data!;
    }
    // print(messageText);
    dynamic getReplyMap =
        (messageText.runtimeType.toString() == '_Map<String, dynamic>')
            ? messageText.containsKey('replyTo')
                ? jsonDecode(messageText['replyTo'])
                : false
            : false;

    if (getReplyMap.runtimeType != bool) {
      messageRowReply = MessageRow.fromJson(getReplyMap);
    }
    return messageRowReply;
  }

  String getStringMessage() {
    String messageText = "";
    try {
      dynamic getMessageText = jsonDecode(data);
      messageText = getMessageText['text'];
    } catch (e) {
      messageText = data!;
    }
    return messageText;
  }

  String messageText({
    ChatChannel channel = ChatChannel.empty,
    ChatUser currentUser = ChatUser.empty,
  }) {
    dynamic displayText = data!;

    int? leaveBlock;
    dynamic decodedChannelData;
    if (channel.chatFlag == "2") {
      decodedChannelData = jsonDecode(channel.channelData!);
      leaveBlock = decodedChannelData['leave_block'];
    }
    String lblLeftchat = "chat_section.lbl_left_chat".tr();
    String lblBlockedChat = "chat_section.lbl_blocked_chat".tr();

    if (cardType == "NewChannelForRequest") {
      displayText = "chat_section.lbl_agent_initiate_chat".tr();
    } else if (cardType == "NewChannelForPrivateChat") {
      displayText = "chat_section.lbl_member_initiate_private_chat".tr();
    } else if (cardType == "propertyDetail") {
      displayText = 'chat_section.lbl_new_property_shared'
          .tr(); // Agent shared Property with members
    } else if (cardType == "firstMessage" || cardType == 'newPropertyRequest') {
      displayText =
          "chat_section.lbl_new_property_request".tr(); // New Property request
    } else if (cardType == "onlyImages" || cardType == "onlyMedia") {
      displayText = "chat_section.lbl_new_image_shared".tr();
    } else if (cardType == "mediaPlaceholder") {
      displayText = "chat_section.lbl_new_image_shared".tr();
    } else if (cardType == "privateProperty") {
      displayText = "chat_section.lbl_new_property_shared".tr();
    } else if (cardType == "URL") {
      displayText = 'chat_section.lbl_link_shared'.tr();
    } else if (cardType == "privatePropertyPlaceholder") {
      displayText = "chat_section.lbl_new_property_shared".tr();
    } else if (cardType == "call") {
      displayText = "chat_section.lbl_call_me".tr();
    } else if (cardType == "whatsapp") {
      displayText = "chat_section.lbl_contact_me_whats_app".tr();
    } else if (cardType == "chatEnded") {
      if (decodedChannelData.containsKey('type') &&
          decodedChannelData['type'] != "private_chat") {
        if (channel.chatFlag == "2" &&
            leaveBlock == int.parse(currentUser.userId)) {
          displayText = "chat_section.lbl_you_left_the_chat".tr();
        } else {
          displayText = "${channel.chatToUser.first.username} $lblLeftchat";
        }
      } else {
        if (channel.chatFlag == "2" &&
            leaveBlock == int.parse(currentUser.userId)) {
          displayText = "chat_section.lbl_you_block_this_chat".tr();
        } else {
          displayText = "${channel.chatToUser.first.username} $lblBlockedChat";
        }
      }
    } else if (cardType == "text") {
      try {
        displayText = data["text"];
      } catch (e) {
        dynamic getText = jsonDecode(data!);
        try {
          displayText = getText['text'];
        } catch (e) {
          displayText = getText.toString();
        }
      }
    }
    return displayText.toString();
  }

  MessageContent.fromJson(Map<String, dynamic> json)
      : cardType = json['cardType'],
        data = json['data'],
        timeStamp = json['timeStamp'];

  Map<String, dynamic> toJson() =>
      {'cardType': cardType, 'data': data, 'timeStamp': timeStamp};

  @override
  toString() =>
      '{"cardType": "$cardType", "data": $data, "timeStamp": "$timeStamp"}';
}

class Message {
  final String? userId;
  final String? channelName;
  final MessageContent? content;
  final String? timetoken;

  static const empty = Message(
    userId: '',
    channelName: '',
    content: MessageContent.empty,
    timetoken: '',
  );

  const Message({
    this.userId,
    this.channelName,
    this.content,
    this.timetoken,
  });

  Message copyWith(
      {String? userId,
      String? channelName,
      MessageContent? content,
      String? timetoken}) {
    Message messageBack = Message(
      userId: userId ?? this.userId,
      channelName: channelName ?? this.channelName,
      content: content ?? this.content,
      timetoken: timetoken ?? this.timetoken,
    );
    return messageBack;
  }

  Message.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        channelName = json['channel'],
        timetoken = json['timetoken'],
        content =
            (json['content'].runtimeType.toString() == '_Map<String, dynamic>')
                ? MessageContent.fromJson(json['content'])
                : MessageContent.fromJson(json['content'].runtimeType != Null
                    ? jsonDecode(json['content'].toString())
                    : {});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'channelName': channelName,
        'timetoken': timetoken,
        'content': content,
      };

  @override
  toString() =>
      '{"userId": "$userId", "content": ${jsonEncode(content)} , "timetoken": "$timetoken"}';
}

class MessageRow {
  final String messageId;
  final String channelName;
  final Message message;
  final ChatUser chatUser;
  final String timeStamp;

  static const empty = MessageRow(
    messageId: '',
    channelName: '',
    message: Message.empty,
    chatUser: ChatUser.empty,
    timeStamp: '',
  );

  const MessageRow({
    required this.messageId,
    required this.channelName,
    required this.message,
    required this.chatUser,
    required this.timeStamp,
  });

  MessageRow copyWith({
    required String messageId,
    required String channelName,
    required Message message,
    required ChatUser chatUser,
    required String timeStamp,
  }) {
    MessageRow messageBack = MessageRow(
      messageId: messageId,
      channelName: channelName,
      chatUser: chatUser,
      message: message,
      timeStamp: timeStamp,
    );
    return messageBack;
  }

  MessageRow.fromJson(Map<String, dynamic> json)
      : messageId = json['messageId'],
        channelName = json['channelName'],
        message =
            (json['message'].runtimeType.toString() == '_Map<String, dynamic>')
                ? Message.fromJson(json['message'])
                : Message.fromJson(jsonDecode(json['message'])),
        timeStamp = json['timeStamp'],
        chatUser = ChatUser.fromJson(
          json['chatUser'],
        );

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'channelName': channelName,
        'message': message,
        'timeStamp': timeStamp,
        'chatUser': chatUser.toJson(),
      };

  @override
  String toString() {
    // Must need in the following formate if you want to convert string to json and json to string.
    return '{"messageId": "$messageId", "channelName": "$channelName", "message": ${jsonEncode(message)}, "timeStamp": "$timeStamp", "chatUser": ${jsonEncode(chatUser)} }';
  }
}

class ChatChannel {
  final String channelName;
  final MessageRow lastMessageRow;
  final String lastMessageTime;
  // Each channel hold last 10 messages
  final List<MessageRow>? messagesRow;
  final ChatUser chatUser;
  final List<ChatUser> chatToUser;
  final String channelId;
  final String unreadMessageCount;
  final String? chatFlag;
  final String? channelData;
  final String? typingIndicator;
  final String? typingIndicatorStartTime;
  final String? lastVisitTime;
  final String? lastMessageSentTime;
  final int totalNumberOfMessages;

  final String? disableTypingMessage;

  const ChatChannel({
    required this.channelName,
    required this.lastMessageRow,
    required this.lastMessageTime,
    required this.chatUser,
    required this.chatToUser,
    required this.channelId,
    required this.unreadMessageCount,
    this.chatFlag,
    this.channelData,
    this.typingIndicator,
    this.typingIndicatorStartTime,
    this.lastVisitTime,
    this.lastMessageSentTime = "16871555519911730",
    this.messagesRow,
    this.disableTypingMessage,
    this.totalNumberOfMessages = 0,
  });

  static const empty = ChatChannel(
    channelId: '',
    channelName: '',
    chatUser: ChatUser.empty,
    chatToUser: [],
    lastMessageTime: '',
    lastMessageRow: MessageRow.empty,
    unreadMessageCount: '0',
    channelData: '',
    chatFlag: '',
    typingIndicator: '',
    typingIndicatorStartTime: '',
    lastVisitTime: '',
    messagesRow: [],
    disableTypingMessage: '',
  );

  ChatChannel.fromJson(Map<String, dynamic> json)
      : channelName = json['channelName'],
        lastMessageRow = MessageRow.fromJson(json['lastMessage']),
        lastMessageTime = json['lastMessageTime'],
        channelId = json['channelId'],
        unreadMessageCount = json['unreadMessageCount'],
        chatFlag = json['chatFlag'],
        disableTypingMessage = json['disableTypingMessage'],
        channelData = json['channelData'],
        messagesRow = json['messages'] != null
            ? List<MessageRow>.from(
                json['messages'].map(
                  (x) => MessageRow.fromJson(x),
                ),
              )
            : [],
        typingIndicator = '',
        typingIndicatorStartTime = '',
        lastVisitTime = '',
        chatToUser = [],
        lastMessageSentTime = '',
        totalNumberOfMessages = json['chatCount'],
        chatUser = ChatUser.fromJson(
          json['chatUser'],
        );

  Map<String, dynamic> toJson() => {
        'channelName': channelName,
        'lastMessage': lastMessageRow,
        'lastMessageTime': lastMessageTime,
        'channelId': channelId,
        'unreadMessageCount': unreadMessageCount,
        'chatFlag': chatFlag,
        'chatUser': chatUser.toJson(),
        'channelData': channelData,
        'lastVisitTime': lastVisitTime,
        'chatCount': totalNumberOfMessages,
        'messages': messagesRow != null
            ? List<dynamic>.from(messagesRow!.map((x) => x.toJson()))
            : [],
      };

  @override
  String toString() {
    // Must need in the following formate if you want to convert string to json and json to string.
    return '{"channelId" : $channelId, "channelName": "$channelName",  "lastMessageTime": "$lastMessageTime", "unreadMessageCount": "$unreadMessageCount", "chatFlag": "$chatFlag", "chatUser": "${chatUser.toString()}, "typingIndicatorStartTime": "$typingIndicatorStartTime", "typingIndicator": "$typingIndicator",  "lastVisitTime": "$lastVisitTime", "lastMessage": "$lastMessageRow", "channelData":"$channelData", "lastMessageSentTime":"$lastMessageSentTime", "totalNumberOfMessages": $totalNumberOfMessages, "messages": ${jsonEncode(messagesRow)}}';
  }

  ChatChannel copyWith({
    MessageRow? lastMessageRow,
    String? lastMessageTime,
    String? unreadMessageCount,
    String? chatFlag,
    List<ChatUser>? chatToUser,
    String? channelData,
    String? typingIndicatorStartTime,
    String? typingIndicator,
    String? lastVisitTime,
    String? lastMessageSentTime,
    List<MessageRow>? messagesRow,
    String? disableTypingMessage,
    int? totalNumberOfMessages,
  }) {
    return ChatChannel(
      channelId: channelId,
      channelName: channelName,
      chatUser: chatUser,
      chatToUser: chatToUser ?? this.chatToUser,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      chatFlag: chatFlag ?? this.chatFlag,
      channelData: channelData ?? this.channelData,
      messagesRow: messagesRow ?? this.messagesRow,
      lastMessageRow: lastMessageRow ?? this.lastMessageRow,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      typingIndicator: typingIndicator ?? this.typingIndicator,
      lastVisitTime: lastVisitTime ?? this.lastVisitTime,
      lastMessageSentTime: lastMessageSentTime ?? this.lastMessageSentTime,
      typingIndicatorStartTime:
          typingIndicatorStartTime ?? this.typingIndicatorStartTime,
      disableTypingMessage: disableTypingMessage ?? this.disableTypingMessage,
      totalNumberOfMessages:
          totalNumberOfMessages ?? this.totalNumberOfMessages,
    );
  }
}
