part of 'chat_bloc.dart';

enum ChatStatus {
  initial,
  loading,
  loadinghistory,
  loadingNewMessages,
  loadinghistoryDone,
  error,
  started, // Treat it as success
  typingOn,
  typingOff,
  sending,
  receiving,
  sent,
  paused,
  threadUpdated,
  chatClosed,
  endChat,
  updateChatFlag,
  movedToChannel,
  movedToChat,
  deleteMessage
}

class ChatState extends Equatable {
  const ChatState({
    this.currentMessage = "",
    this.typingIndicatorText = "",
    this.status = ChatStatus.initial,
    this.currentUser = ChatUser.empty,
    this.toUsers = const <ChatUser>[],
    this.currentChannelThread = const <MessageRow>[],
    this.currentChannel = ChatChannel.empty,
    this.hasReachedMin = false,
    this.typingIndicatorTextStartTime = "",
    this.disableTypingMessage = "",
    this.replyTo = "",
    this.replyToChannelId = "",
  });

  final ChatStatus status;
  final ChatUser currentUser;
  final String currentMessage;
  final List<ChatUser> toUsers;
  final List<MessageRow> currentChannelThread;
  final ChatChannel currentChannel;
  final String typingIndicatorText;
  final String typingIndicatorTextStartTime;
  final bool hasReachedMin;
  final String disableTypingMessage;
  final String replyTo;
  final String replyToChannelId;

  ChatState copyWith(
      {ChatStatus? status,
      List<ChatUser>? toUsers,
      String? currentMessage,
      List<MessageRow>? currentChannelThread,
      ChatUser? currentUser,
      ChatChannel? currentChannel,
      String? typingIndicatorText,
      bool? hasReachedMin,
      String? disableTypingMessage,
      String? replyTo,
      String? replyToChannelId}) {
    ChatState chatState = ChatState(
      status: status ?? this.status,
      toUsers: toUsers ?? this.toUsers,
      currentMessage: currentMessage ?? this.currentMessage,
      currentChannelThread: currentChannelThread ?? this.currentChannelThread,
      currentUser: currentUser ?? this.currentUser,
      currentChannel: currentChannel ?? this.currentChannel,
      typingIndicatorText: typingIndicatorText ?? this.typingIndicatorText,
      typingIndicatorTextStartTime: "$typingIndicatorText".isEmpty
          ? ''
          : app_instance.utility.getUnixTimeStampInPubNubPrecision(),
      hasReachedMin: hasReachedMin ?? this.hasReachedMin,
      disableTypingMessage: disableTypingMessage ?? this.disableTypingMessage,
      replyTo: replyTo ?? this.replyTo,
      replyToChannelId: replyToChannelId ?? this.replyToChannelId,
    );

    return chatState;
  }

  // only  disableTypingMessage send to state
  ChatState copyWithTypingState({
    String? disableTypingMessage,
    ChatStatus? status,
  }) {
    ChatState chatState = ChatState(
      status: status ?? this.status,
      toUsers: toUsers,
      currentMessage: currentMessage,
      currentChannelThread: currentChannelThread,
      currentUser: currentUser,
      currentChannel: currentChannel,
      typingIndicatorText: typingIndicatorText,
      typingIndicatorTextStartTime: typingIndicatorTextStartTime,
      hasReachedMin: hasReachedMin,
      disableTypingMessage: disableTypingMessage ?? this.disableTypingMessage,
    );
    return chatState;
  }

  String validateEnableTyping(
      {required List<MessageRow> chatThread,
      required ChatChannel validateCurrentChannel,
      int maxMessageLength = 15}) {
    String messageForDisableChatting = "";
    String lblNeedToWait = "chat_section.lbl_need_to_wait".tr();
    String lblMinute = "chat_section.lbl_min".tr();
    int maximumMessageLimit =
        int.parse(dotenv.env['MAX_MESSAGE_PAUSE'].toString());

    if (validateCurrentChannel != ChatChannel.empty) {
      // chatFlag 4 deactive channel message
      if (int.parse(validateCurrentChannel.channelId) > 2) {
        if (app_instance.utility.validateOwnerShip(validateCurrentChannel) ==
            false) {
          return messageForDisableChatting = '-';
        }

        // chat leave by one of the user
        dynamic decodedChannelData =
            jsonDecode(validateCurrentChannel.channelData.toString());
        String lblLeftchat = "chat_section.lbl_left_chat".tr();

        if (decodedChannelData['type'] != "private_chat") {
          if (validateCurrentChannel.chatFlag == "2") {
            if (int.parse(currentUser.userId) ==
                decodedChannelData['leave_block']) {
              return messageForDisableChatting =
                  "chat_section.lbl_you_left_the_chat".tr();
            } else {
              return messageForDisableChatting =
                  "${validateCurrentChannel.chatToUser.first.username} $lblLeftchat";
            }
          }
          if (validateCurrentChannel.chatFlag == '4') {
            return messageForDisableChatting =
                "chat_section.lbl_channel_deactive_successfully".tr();
          }
        }

        String lblBlockedYou = "chat_section.lbl_blocked_you".tr();

        if (validateCurrentChannel.chatToUser.first.userId == "null" ||
            validateCurrentChannel.chatToUser.first.userId == "0") {
          messageForDisableChatting =
              "chat_section.lbl_user_not_available".tr();
        }

        // blocked channel
        if (decodedChannelData['type'] == "private_chat") {
          if (validateCurrentChannel.chatFlag == "2") {
            if (int.parse(currentUser.userId) ==
                decodedChannelData['leave_block']) {
              return messageForDisableChatting =
                  "chat_section.lbl_you_block_this_chat".tr();
            } else {
              messageForDisableChatting =
                  "${validateCurrentChannel.chatToUser.first.username} $lblBlockedYou";
            }
          }
        }

        // check more conditions - accidental issue
        //  for request_prop - left chat.
        if (decodedChannelData['type'] != "private_chat") {
          if (validateCurrentChannel.chatFlag == "3" &&
              decodedChannelData['leave_block'] ==
                  int.parse(currentUser.userId)) {
            return messageForDisableChatting =
                "chat_section.lbl_you_left_the_chat".tr();
          }

          if (validateCurrentChannel.chatFlag == "3" &&
              decodedChannelData['leave_block'] !=
                  int.parse(currentUser.userId)) {
            return messageForDisableChatting =
                "${validateCurrentChannel.chatToUser.first.username} $lblLeftchat";
          }
        } // for private_chat - block chat.
        else {
          if (decodedChannelData['leave_block'] != 0) {
            if (validateCurrentChannel.chatFlag == "2") {
              if (int.parse(currentUser.userId) ==
                  decodedChannelData['leave_block']) {
                return messageForDisableChatting =
                    "chat_section.lbl_you_block_this_chat".tr();
              } else {
                messageForDisableChatting =
                    "${validateCurrentChannel.chatToUser.first.username} $lblBlockedYou";
              }
            } else if (validateCurrentChannel.chatFlag == "3" &&
                decodedChannelData['leave_block'] ==
                    int.parse(currentUser.userId)) {
              return messageForDisableChatting =
                  "chat_section.lbl_you_block_this_chat".tr();
            } else if (validateCurrentChannel.chatFlag == "3" &&
                decodedChannelData['leave_block'] != '0' &&
                decodedChannelData['leave_block'] !=
                    int.parse(currentUser.userId)) {
              return messageForDisableChatting =
                  "${validateCurrentChannel.chatToUser.first.username} $lblBlockedYou";
            } else if (validateCurrentChannel.chatFlag == '4') {
              if (decodedChannelData.containsKey('leave_block') != '0') {
                if (int.parse(currentUser.userId) ==
                    decodedChannelData['leave_block']) {
                  return messageForDisableChatting =
                      "chat_section.lbl_you_block_this_chat".tr();
                } else {
                  messageForDisableChatting =
                      "${validateCurrentChannel.chatToUser.first.username} $lblBlockedYou";
                }
              }
              return messageForDisableChatting;
            }
          }
        }

        // for 3 messages in one on one chat -------------
        List<String> sameUserMessage = [];

        if (chatThread.length >= maximumMessageLimit &&
            validateCurrentChannel.chatFlag == '1') {
          int maxElementToCheck = 0;
          for (MessageRow message in chatThread.reversed) {
            if (message.chatUser.userId == currentUser.userId) {
              sameUserMessage.add(message.chatUser.userId);
            }
            if (message.chatUser.userId != currentUser.userId) {
              sameUserMessage.clear();
              return "";
            }

            if (sameUserMessage.length >= maxMessageLength) {
              return messageForDisableChatting =
                  "chat_section.lbl_wait_for_otherParty_responds".tr();
            }
            maxElementToCheck++;
            if (maxElementToCheck > maximumMessageLimit) {
              break;
            }
          }
        }
      } else {
        // public channel 1 hrs condition
        for (MessageRow message in chatThread) {
          if (message.chatUser.userId == currentUser.userId) {
            int timeRemainingToSendMessage = app_instance.utility
                .getOneHourMessageValidation(message.timeStamp);
            if (timeRemainingToSendMessage > 0) {
              return messageForDisableChatting = "$timeRemainingToSendMessage";
            }
          }
        }
      }
    }
    return messageForDisableChatting;
  }

  factory ChatState.fromJson(Map<String, dynamic> json) {
    try {
      ChatStatus status =
          ChatStatus.values.firstWhere((e) => e.toString() == json['status']);

      List<MessageRow> currentChannelThread = [];
      if (json['currentChannelThread'] != null &&
          json['currentChannelThread'].length > 0) {
        List currentUserMessageArray = json['currentChannelThread'];
        for (int i = 0; i < currentUserMessageArray.length; i++) {
          currentChannelThread
              .add(MessageRow.fromJson(currentUserMessageArray[i]));
        }
      }

      List<ChatUser> chatUser = [];
      if (json['toUsers'].length > 0) {
        List toUsersArray = json['toUsers'];
        for (int i = 0; i < toUsersArray.length; i++) {
          chatUser.add(ChatUser.fromJson(toUsersArray[i]));
        }
      }

      List<ChatChannel> channelList = [];
      if (json['channelList'].length > 0) {
        List channelListArray = json['channelList'];
        for (int i = 0; i < channelListArray.length; i++) {
          if (channelList.contains(channelListArray[i]) == false) {
            channelList.add(ChatChannel.fromJson(channelListArray[i]));
          }
        }
      }

      ChatState chatState = ChatState(
        status: status,
        currentMessage: json['currentMessage'] as String,
        currentChannelThread: currentChannelThread,
        toUsers: chatUser,
        currentChannel: ChatChannel.fromJson(json['currentChannel']),
        currentUser: ChatUser.fromJson(json['currentUser']),
        typingIndicatorText: json['typingIndicatorText'] as String,
        hasReachedMin: json['hasReachedMin'] as bool,
      );

      return chatState;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      String currentChannelThreadString = '';

      for (var element in currentChannelThread) {
        "$currentChannelThreadString, ${element.toJson()}";
      }

      return {
        'status': status.toString(),
        'toUsers': toUsers,
        'currentMessage': currentMessage,
        'currentChannelThread': currentChannelThread,
        'currentUser': currentUser,
        'currentChannel': currentChannel,
        'typingIndicatorText': typingIndicatorText,
        'hasReachedMin': hasReachedMin,
      };
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
      rethrow;
    }
  }

  @override
  String toString() {
    return 'ChatState{status: "$status" ,toUsers: "$toUsers", currentMessage: "$currentMessage",currentChannelThread: "$currentChannelThread", currentUser: "$currentUser", currentChannel: "$currentChannel", typingIndicatorText: "$typingIndicatorText", hasReachedMin: "$hasReachedMin"}';
  }

  @override
  List<Object> get props => [
        status,
        toUsers,
        currentMessage,
        currentChannelThread,
        currentUser,
        currentChannel,
        typingIndicatorText,
        hasReachedMin
      ];
}
