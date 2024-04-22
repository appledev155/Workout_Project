import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/isar/channel/channel_isar.dart';
import 'package:anytimeworkout/isar/message/message_isar.dart';
import 'package:anytimeworkout/module/chat/bloc/upload_progress_bloc/upload_progress_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pubnub/pubnub.dart';

import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';

import '../../config/chat_config.dart';
import '../../../../model/user_model.dart';
import '../../model/chat_model.dart';
import '../../repo/chat_repo.dart';
import '../channel/channel_bloc.dart';

/// Isar Packages
import 'package:anytimeworkout/isar/user/user.dart' as user_store;
import 'package:anytimeworkout/isar/message/message_row.dart' as message_store;
import 'package:anytimeworkout/isar/channel/channel.dart' as channel_store;

import 'package:anytimeworkout/config.dart' as app_instance;

/// Isar Packages

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final CurrentUserBloc currentUserBloc;
  late final ChannelBloc channelBloc;

  late UserModel? currentUser;
  late ChatRepo chatRepo;
  late UploadProgressBloc uploadProgressBloc;

  user_store.User userStore = user_store.User();
  message_store.MessageRow messageStore = message_store.MessageRow();
  channel_store.Channel channelStore = channel_store.Channel();

  ChatUser _chatUser;
  ChatUser get chatUser => _chatUser;

  StreamSubscription<Envelope>? _envelopStreamChatBloc;
  StreamSubscription<UserModel>? _currentUserStreamChatBloc;
  StreamSubscription<CurrentUserState>? _chatRepoStreamChatBloc;
  StreamSubscription<UploadBox>? _uploadProgressStream;

  // TO DO: removed after checking
  StreamController uploadStatus = StreamController<String>.broadcast();

  ChatBloc(
      {required currentUserBloc,
      required this.channelBloc,
      required uploadProgressBloc})
      : currentUser = currentUserBloc.state.currentUser,
        chatRepo = currentUserBloc.state.chatRepo,
        _chatUser = ChatUser(
          userId: currentUserBloc.state.currentUser!.id.toString(),
          username: currentUserBloc.state.currentUser!.name.toString(),
          userImage: currentUserBloc.state.currentUser!.profileImage.toString(),
          roleTypeId: currentUserBloc.state.currentUser!.roleId.toString(),
        ),
        super(const ChatState(status: ChatStatus.initial)) {
    on<CreateChannel>(_onCreateChannel);
    on<ChatInitiated>(_onChatInitiated, transformer: restartable());
    on<SyncMessages>(_onSyncMessages, transformer: restartable());
    on<ShowTypingIndicator>(_onShowTypingIndicator);
    on<ChatFetched>(_onChatFetched, transformer: droppable());
    on<ChatMessageUpdated>(_onChatMessageUpdated);
    on<ChatMessageSent>(_onChatMessageSent, transformer: sequential());
    on<ChatMessageReceived>(_onChatMessageReceived, transformer: sequential());
    on<SignalReceived>(_onSignalReceived, transformer: sequential());
    on<SignalSent>(_onSignalSent, transformer: sequential());

    on<ClearHistory>(_onClearHistory);
    on<ResetChat>(_onResetChat);
    on<ResetCurrentChannelThread>(_onResetCurrentChannelThread);
    on<EndChat>(_onEndChat);

    on<MediaShared>(_onMediaShared);
    on<ResetDisableTypingMessage>(_onResetDisableTypingMessage);
    on<CheckTypingIndicatorValidate>(_onCheckTypingIndicatorValidate);
    on<ValidateMessaging>(_onValidateMessaging);
    on<ResetTypingBoxPlaceholder>(_onResetTypingBoxPlaceholder);
    on<UpdateMessage>(_onUpdateMessage);
    on<UpdateCurrentUser>(_onUpdateCurrentUser);

    _currentUserStreamChatBloc =
        currentUserBloc.appUserStream.stream.listen((currentUserEvent) {
      _chatUser = ChatUser(
        userId: currentUserEvent!.id.toString(),
        username: currentUserEvent!.name.toString(),
        userImage: currentUserEvent!.profileImage.toString(),
        roleTypeId: currentUserEvent!.roleId.toString(),
      );
      currentUser = currentUserEvent;
    });

    _envelopStreamChatBloc =
        currentUserBloc.appEnvelopStream.stream.listen((envelope) {
      if (state.currentChannel.channelName != envelope.channel) return;
      // print("***********Debug**********");
      // print("${envelope.messageType} MessageType");
      // print("${envelope.channel} ChannelName");
      // print("${envelope.timetoken} TimeToken");
      // print("${envelope.uuid} -- UserId");
      // print("${chatUser.userId.toString()} currentUserID");
      // print("***********Debug**********");
      // print("${envelope.channel} *** inchatbloc***");

      envelopEvents(envelope);
    });

    _chatRepoStreamChatBloc = currentUserBloc.appChatRepoStream.stream
        .listen((currentUserStateEvent) {
      chatRepo = currentUserStateEvent.chatRepo;
    });

    // uploadProgressBloc.uploadStream.stream.listen((progressBlocStream) {
    //   print("print progressBlocStream  ${progressBlocStream.toString()}");
    // });

    uploadProgressBloc.uploadStream.stream.listen((uploadbox) {
      try {
        add(MediaShared(uploadBox: uploadbox));
      } catch (e) {
        print('e: $e \n uploadbox: ${uploadbox.toString()}');
      }
    });
  }

  envelopEvents(envelope) {
    switch (envelope.messageType) {
      case MessageType.normal:
        String messageContents = envelope.content.toString();
        if (state.currentChannel.channelName != envelope.channel) return;

        // Map<String, dynamic> messageContents = envelope.content;

        // Removed to sync mulitple dvices

        if (envelope.content.runtimeType.toString() == "List<dynamic>") {
          dynamic getText = jsonDecode(messageContents.toString());
          dynamic getCardType = getText[0]['text'];
          print(getText.toString());
          // getCardType['cardType'] == "updateMessageNotification" ||
          if (getCardType['cardType'] == "deleteMessageNotification" ||
              getCardType['cardType'] == "userDeleted") {
            add(UpdateMessage(
                notificationData: jsonEncode(getText),
                notificationType: getCardType['cardType'].toString()));
          }
        }

        if (envelope.uuid.toString() != currentUser!.id.toString() ||
            state.status == ChatStatus.loadingNewMessages) {
          // print("***********Debug chat bloc**********");
          // print("${envelope.messageType} MessageType");
          // print("${envelope.content.toString()} Message");
          // print("${envelope.channel} ChannelName");
          // print("${envelope.timetoken} TimeToken");
          // print("${envelope.uuid} -- UserId");
          // print("${chatUser.userId.toString()} currentUserID");
          // print("***********Debug chat bloc end **********");
          // print("${envelope.channel} *** inchatbloc***");

          if (envelope.content.runtimeType.toString() != "List<dynamic>") {
            // for Laravel Server notification no need to check
            dynamic getText = jsonDecode(messageContents.toString());
            dynamic getCardType = jsonDecode(getText['text'].toString());

            if (cardTypePlaceholderList.contains(getCardType['cardType']) ==
                false) {
              add(ChatMessageReceived(
                message: messageContents,
                channelName: envelope.channel,
                senderUserId: envelope.uuid.toString(),
                timetoken: envelope.timetoken.toString(),
              ));
            }
          }
        } // to display the uuid of the sender
        break;
      case MessageType.signal:
        if (envelope.uuid.toString() != currentUser!.id.toString()) {
          String messageContents = envelope.content.toString();
          // REMOVE function and event ShowTypingIndicator We are using SignalReceived event
          // add(ShowTypingIndicator(envelope.content.toString(), envelope.channel,
          //     envelope.uuid.toString()));
          add(SignalReceived(
            message: messageContents,
            channelName: envelope.channel,
            senderUserId: envelope.uuid.toString(),
            timetoken: envelope.timetoken.toString(),
          ));
        }

        break;
      default:
        if (kDebugMode) {
          print('${envelope.publishedBy} sent a message: ${envelope.content}');
        }
    }
  }

  _onUpdateMessage(UpdateMessage event, Emitter<ChatState> emit) async {
    String? messageId = event.messageId.toString();
    String userId = "";
    if (event.messageId.runtimeType == Null || event.messageId!.isEmpty) {
      dynamic decodedMessage = jsonDecode(event.notificationData);
      dynamic messageText = decodedMessage[0]['text'];
      dynamic messageData = messageText['data'];
      dynamic decodedMessageData = jsonDecode(messageData.toString());
      String serverMessageId = decodedMessageData['messageId'].toString();
      userId = decodedMessageData['userId'].toString();
      String channelId = decodedMessageData['channelId'].toString();
      String timeToken = decodedMessageData['timetoken'].toString();
      messageId = "$userId-$channelId-$timeToken";
    }

    if (event.notificationType == "deleteMessageNotification") {
      await messageStore.deleteMessageByMessageId(messageId);
      List<MessageRow> currentChannelThread = state.currentChannelThread;
      currentChannelThread
          .removeWhere((element) => element.messageId == messageId);
      emit(state.copyWith(
          currentChannelThread: currentChannelThread,
          status: ChatStatus.threadUpdated));
    }

    // delete messages from state and isar which is sended by deleted user
    if (event.notificationType == "userDeleted") {
      await messageStore.clearDeletedUserMessages(userId);
      List<MessageRow> currentChannelThread = state.currentChannelThread;
      currentChannelThread.removeWhere(
          (element) => element.message.userId.toString() == userId.toString());
      emit(state.copyWith(
          currentChannelThread: currentChannelThread,
          status: ChatStatus.threadUpdated));
    }

    if (event.notificationType == "updateMessageNotification") {
      emit(state.copyWith(status: ChatStatus.receiving));
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
      await messageStore.saveMessage(saveMessage);
      // ** Save to Isar Message - Users  */
      if (messageRow.channelName.toString() ==
          state.currentChannel.channelName) {
        List<MessageRow> currentChannelThread = state.currentChannelThread;
        currentChannelThread.removeWhere((element) {
          return (element.messageId == 'null' ||
              element.messageId.runtimeType == Null ||
              element.messageId == messageRow.messageId);
        });
        currentChannelThread.add(messageRow);

        currentChannelThread.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

        emit(state.copyWith(
            currentChannelThread: currentChannelThread,
            status: ChatStatus.threadUpdated));
      }
    }
  }

  /// Create Channel
  _onCreateChannel(CreateChannel event, Emitter<ChatState> emit) async {
    ChatChannel chatChannel;
    emit(state.copyWith(status: ChatStatus.loading));
    chatChannel =
        await generateChannelName(event.chatToUser.userId, event.propRequestId);
    emit(state.copyWith(
      status: ChatStatus.started,
      currentChannel: ChatChannel(
        channelName: chatChannel.channelName,
        lastMessageRow: chatChannel.lastMessageRow,
        lastMessageTime: chatChannel.lastMessageRow.timeStamp,
        chatUser: chatChannel.chatUser,
        chatToUser: [event.chatToUser],
        channelId: chatChannel.channelId,
        unreadMessageCount: chatChannel.unreadMessageCount,
        channelData: jsonDecode(
          chatChannel.channelData.toString(),
        ),
      ),
    ));
  }

  /// Initiate Chat
  void _onChatInitiated(ChatInitiated event, Emitter<ChatState> emit) async {
    ChatChannel currentChannel = event.currentChannel;
    String disableTypingMessage = "";
    bool newChannel = false;
    // Create new Channel
    if (event.currentChannel == ChatChannel.empty) {
      currentChannel =
          await generateChannelName(event.chatToUser.first.userId, '');
      newChannel = true;
      emit(
        state.copyWith(
          status: ChatStatus.initial,
          currentChannelThread: [],
          toUsers: event.chatToUser,
          currentChannel: currentChannel,
          replyTo: event.replyTo,
          replyToChannelId: event.replyToChannelId,
          disableTypingMessage: "",
        ),
      );
    } else {
      // validate the channel access
      disableTypingMessage =
          event.currentChannel.disableTypingMessage.runtimeType != Null
              ? (event.currentChannel.channelId == "" ||
                      event.currentChannel.channelId.isEmpty)
                  ? ""
                  : (int.parse(event.currentChannel.channelId) > 2)
                      ? event.currentChannel.disableTypingMessage.toString()
                      : state.validateEnableTyping(
                          chatThread: state.currentChannelThread,
                          validateCurrentChannel: state.currentChannel,
                        )
              : "";

      List<MessageRow> currentChannelThread = [];
      if (currentChannel.messagesRow.runtimeType != Null) {
        // Temp Removed beacuse of isar save issue
        // currentChannelThread = currentChannel.messagesRow!;
      }

      emit(state.copyWith(
        status: ChatStatus.started,
        hasReachedMin: false,
        toUsers: event.chatToUser,
        currentChannel: currentChannel,
        currentChannelThread: [...currentChannelThread],
        replyTo: event.replyTo,
        replyToChannelId: event.replyToChannelId,
        disableTypingMessage: disableTypingMessage,
      ));
    }

    if (_uploadProgressStream?.isPaused == true) {
      print("check if uploading stream paused");
      _uploadProgressStream?.resume();
    }

    ChatChannel chatChannel = currentChannel;

    chatChannel = chatChannel.copyWith(
        lastVisitTime:
            app_instance.utility.getUnixTimeStampInPubNubPrecision());

    ChatUser currentChatUser = chatUser;

    List<ChatUser> toUsers = [...event.chatToUser, chatUser];

    if (event.currentChannel.channelId != "" ||
        event.currentChannel.channelId.isNotEmpty) {
      emit(
        state.copyWith(
            currentChannel: chatChannel,
            status: (int.parse(event.currentChannel.channelId) > 2)
                ? ChatStatus.loading
                : (event.currentChannel.disableTypingMessage != "")
                    ? ChatStatus.movedToChat
                    : ChatStatus.loading,
            typingIndicatorText: '',
            currentUser: currentChatUser,
            toUsers: toUsers,
            replyTo: event.replyTo,
            replyToChannelId: event.replyToChannelId,
            disableTypingMessage: disableTypingMessage),
      );
    } else {
      emit(
        state.copyWith(
            currentChannel: chatChannel,
            status: ChatStatus.loading,
            typingIndicatorText: '',
            currentUser: currentChatUser,
            toUsers: toUsers,
            disableTypingMessage: "",
            replyTo: event.replyTo,
            replyToChannelId: event.replyToChannelId),
      );
    }

    String startTime = app_instance.utility.getUnixTimeStampInPubNubPrecision();
    // Loading message from Storage
    if (state.currentChannelThread.isEmpty && newChannel == false) {
      dynamic getMessageFromLocalStore =
          await chatRepo.getMessageFromLocalStorage(
              chatChannel: currentChannel, timeStamp: startTime);

      List<MessageRow> storedMessagesList = [];
      if (getMessageFromLocalStore['chatHistory'].isNotEmpty) {
        storedMessagesList = [...getMessageFromLocalStore['chatHistory']];
      }

      if (storedMessagesList.isNotEmpty) {
        emit(
          state.copyWith(
            currentChannelThread: storedMessagesList,
            status: ChatStatus.loadinghistory,
            currentChannel: currentChannel,
            disableTypingMessage: disableTypingMessage,
          ),
        );
      }
    }
    // Deal with server or network related stuff.
    add(SyncMessages());
  }

  void _onSyncMessages(SyncMessages event, Emitter<ChatState> emit) async {
    if (chatRepo.channelList.contains(state.currentChannel.channelName) ==
        false) {
      await chatRepo.subscribeChatChannel(state.currentChannel);
      print("***Subcribed to New Channel** ${state.currentChannel.channelId}");
    }

    emit(
      state.copyWith(
        status: ChatStatus.loadingNewMessages,
      ),
    );

    // Step 1: For Offline = InternetConnected Message Get Message from local storage
    // Step 2: For Online = InternetDisconnected Message Get Message from Server from current time.
    // Step 3: If message are greater  than 10 then replace current channelThread with server message
    // Step 4: If message are less than 10 then append server message with current channelThread
    // Note: (Get the messages from server between greater than local storage time stamp and less than current time stamp)

    List<MessageRow> severMessagesList = [];
    if (state.currentChannelThread.isEmpty ||
        state.currentChannelThread.length <= 9) {
      // For OLD messsage if message is less than 10
      String startTime =
          app_instance.utility.getUnixTimeStampInPubNubPrecision();
      if (state.currentChannelThread.isNotEmpty) {
        startTime = state.currentChannelThread.last.timeStamp;
      }
      dynamic getMessageFromServerStore = await chatRepo.getMessageFromServer(
          chatChannel: state.currentChannel, timeStamp: startTime);

      if (getMessageFromServerStore['chatHistory'].isNotEmpty) {
        severMessagesList = [...getMessageFromServerStore['chatHistory']];
      }
      print("New Server: ${severMessagesList.length}");

      if (severMessagesList.isNotEmpty) {
        emit(
          state.copyWith(
            currentChannelThread: severMessagesList,
            status: ChatStatus.loading,
          ),
        );
      }
      // For OLD messsage if message is less than 10
    }

    emit(
      state.copyWith(
        status: ChatStatus.loadingNewMessages,
      ),
    );

    String endTime = "";
    if (state.currentChannelThread.isNotEmpty) {
      endTime = state.currentChannelThread.last.timeStamp;
    }

    // Get New Messages from server
    List<MessageRow> newMessageList = [];
    ChatChannel currentChannel = state.currentChannel;
    dynamic getMessageFromServer = await chatRepo.getMessageFromServer(
        chatChannel: state.currentChannel,
        timeStamp: endTime,
        getNewMessages: true);

    if (getMessageFromServer['chatHistory'].isNotEmpty) {
      // clear old stored messages from state and isar db when new messages are 15 and more than 15.
      if (state.currentChannelThread.isNotEmpty &&
          getMessageFromServer['chatHistory'].length == 15) {
        // print("++++++++++++${state.toString()}");
        MessageRow lastMessageTime = getMessageFromServer['chatHistory'].first;
        messageStore.deleteAllMessagesForPerticularChannel(
            currentChannel.channelName.toString(),
            int.parse(lastMessageTime.timeStamp));
        emit(
          state.copyWith(
            currentChannelThread: [],
          ),
        );
      }
      newMessageList = [...getMessageFromServer['chatHistory']];
    }
    int messagePerPage = int.parse(dotenv.env['MESSAGE_PER_PAGE'].toString());
    dynamic currentChanneThread =
        getMessageFromServer.length <= messagePerPage - 1
            ? [...state.currentChannelThread, ...newMessageList]
            : getMessageFromServer;

    String disableTypingMessage = state.validateEnableTyping(
      chatThread: currentChanneThread,
      validateCurrentChannel: currentChannel,
    );

    if (getMessageFromServer.isNotEmpty) {
      emit(
        state.copyWith(
          currentChannelThread: currentChanneThread,
          disableTypingMessage: disableTypingMessage,
          status: ChatStatus.started,
        ),
      );
    } else {
      emit(
        state.copyWith(hasReachedMin: true),
      );
    }

    // Not required now as we are sending notification for blocked chats
    // Chat Flat updating on event now No need to check chatChannelDeteails after each loading.
    // TESTING PHASE - REMOVE AFTER WORKING FINE.
    // String chatFlag = state.currentChannel.chatFlag.toString();
    // if (int.parse(currentChannel.channelId) > 2) {
    //   dynamic getchannelDetails =
    //       await chatRepo.getChannelDetailsById(currentChannel.channelId);

    //   if (getchannelDetails != null) {
    //     try {
    //       getchannelDetails["channel"];
    //     } catch (e, _) {
    //       print('${currentChannel.channelId} request id not found');
    //     }

    //     if (getchannelDetails["channel"].runtimeType != Null) {
    //       Map<dynamic, dynamic> validateChannel = getchannelDetails["channel"]
    //           .map((key, value) => MapEntry(key, value?.toString()));
    //       chatFlag = validateChannel['chatFlag'].toString();
    //     } else {
    //       chatFlag = currentChannel.chatFlag.toString();
    //     }
    //   }
    // }
    // Not required now as we are sending notification for blocked chats

    if (state.currentChannelThread.isNotEmpty) {
      currentChannel = state.currentChannel.copyWith(
          lastMessageRow: state.currentChannelThread.last,
          lastMessageTime: state.currentChannelThread.last.timeStamp,
          lastVisitTime:
              app_instance.utility.getUnixTimeStampInPubNubPrecision(),
          lastMessageSentTime: state.currentChannel.lastMessageSentTime);
    } else {
      currentChannel = state.currentChannel.copyWith(
        lastMessageRow: MessageRow.empty,
        lastMessageTime:
            app_instance.utility.getUnixTimeStampInPubNubPrecision(),
        lastVisitTime: app_instance.utility.getUnixTimeStampInPubNubPrecision(),
      );
    }
    emit(
      state.copyWith(
          currentChannel: currentChannel,
          status: ChatStatus.started,
          hasReachedMin: false,
          disableTypingMessage: disableTypingMessage),
    );

    await updateLocalStorage(currentChannel);
  }

  // Show Typing Indicator
  void _onShowTypingIndicator(
      ShowTypingIndicator event, Emitter<ChatState> emit) async {
    dynamic decodedSignal = jsonDecode(event.message);
    if ((event.channelName == state.currentChannel.channelName) &&
        (event.senderId != currentUser!.id.toString()) &&
        (signalType[int.parse(decodedSignal['signalType'])] == "typingOn")) {
      ChatUser ifNotExist = state.toUsers.firstWhere(
          (element) => element.userId == event.senderId,
          orElse: () => ChatUser.empty);

      if (ifNotExist == ChatUser.empty) {
        ChatUser chatUser = await chatRepo.getChatUser(userId: event.senderId);

        List<ChatUser> toUsers = [...state.toUsers, chatUser];
        emit(state.copyWith(
          typingIndicatorText: chatUser.username,
          currentChannel: state.currentChannel.copyWith(
            typingIndicatorStartTime:
                app_instance.utility.getUnixTimeStampInPubNubPrecision(),
          ),
          toUsers: toUsers,
        ));
      } else {
        ChatUser chatUser = state.toUsers
            .firstWhere((element) => element.userId == event.senderId);
        emit(state.copyWith(
          typingIndicatorText: chatUser.username,
          currentChannel: state.currentChannel.copyWith(
            typingIndicatorStartTime:
                app_instance.utility.getUnixTimeStampInPubNubPrecision(),
          ),
        ));
      }
    } else {
      emit(state.copyWith(
        typingIndicatorText: "",
        currentChannel: state.currentChannel.copyWith(
          typingIndicatorStartTime: "",
        ),
      ));
    }
  }

  Future<void> _onCheckTypingIndicatorValidate(
      CheckTypingIndicatorValidate event, Emitter<ChatState> emit) async {
    if (state.currentChannel.typingIndicatorStartTime != "" &&
        state.currentChannel.typingIndicatorStartTime.runtimeType != Null) {
      var now = DateTime.now();
      var date = DateTime.fromMillisecondsSinceEpoch(
              int.parse(state.currentChannel.typingIndicatorStartTime
                      .toString()) ~/
                  10000,
              isUtc: true)
          .toLocal();
      var diff = now.difference(date);
      if (diff.inSeconds > 5) {
        return emit(state.copyWith(
          typingIndicatorText: "",
        ));
      }
    }
  }

  _onMediaShared(MediaShared event, Emitter<ChatState> emit) async {
    if (_uploadProgressStream?.isPaused == true) {
      _uploadProgressStream?.resume();
    }

    UploadBox uploadBox = event.uploadBox;
    dynamic otherData = jsonDecode(uploadBox.otherData!);
    dynamic getChannelDetails = jsonDecode(otherData['data']);

    ChatChannel mediaForChannel =
        ChatChannel.fromJson(jsonDecode(getChannelDetails['currentChannel']));

    emit(state.copyWith(status: ChatStatus.sending));

    Map<String, dynamic> propertyDetails = {};
    String timestamp = app_instance.utility.getUnixTimeStampInPubNubPrecision();

    if (mediaForChannel.channelName == state.currentChannel.channelName &&
        uploadBox.uploadBoxStatus == UploadBoxStatus.start) {
      return emit(state.copyWith(status: ChatStatus.sending));
    } else if (mediaForChannel.channelName ==
            state.currentChannel.channelName &&
        uploadBox.uploadBoxStatus != UploadBoxStatus.end) {
      return emit(state.copyWith(status: ChatStatus.sending));
    } else if (uploadBox.uploadBoxStatus == UploadBoxStatus.end &&
        otherData['result'].toString() != 'null') {
      MessageContent message = MessageContent.empty;

      // Share only image on Channel
      if (otherData['cardType'] == 'onlyImages' ||
          otherData['cardType'] == 'onlyMedia') {
        propertyDetails = (getChannelDetails.containsKey('replyToData'))
            ? {
                ...jsonDecode(getChannelDetails['replyToData']),
                "propertyImage": otherData['result'].toString()
              }
            : {"propertyImage": otherData['result'].toString()};
        MessageContent selectedProperty = MessageContent(
          cardType: "onlyMedia",
          timeStamp: timestamp,
          data: jsonEncode(propertyDetails),
        );
        message = selectedProperty;
      }

      // Share the Private Property Details on Channel
      if (otherData['cardType'] == 'privateProperty') {
        Map<String, dynamic> propertyAddedDetails =
            jsonDecode(getChannelDetails['propertyDetails'].toString());

        propertyDetails = {"propertyImage": otherData['result'].toString()};
        propertyAddedDetails.addEntries(propertyDetails.entries);

        MessageContent selectedProperty = MessageContent(
          cardType: "privateProperty",
          timeStamp: timestamp,
          data: jsonEncode(propertyAddedDetails),
        );
        message = selectedProperty;
      }

      uploadStatus.sink.add(uploadBox.uniqueId.toString());

      if (message != MessageContent.empty) {
        MessageRow messageRow = MessageRow(
          channelName: mediaForChannel.channelName,
          chatUser: state.currentUser,
          message: Message(
            channelName: mediaForChannel.channelName,
            content: message,
            timetoken: timestamp,
            userId: state.currentUser.userId,
          ),
          messageId:
              "${state.currentUser.userId}-${mediaForChannel.channelId}-$timestamp",
          timeStamp: timestamp,
        );

        if (mediaForChannel.channelName == state.currentChannel.channelName) {
          List<MessageRow> updatedChannelThread = state.currentChannelThread;
          updatedChannelThread.removeWhere(
              (element) => element.messageId == uploadBox.uniqueId);

          emit(state.copyWith(
            currentChannelThread: updatedChannelThread,
            status: ChatStatus.sent,
          ));
          add(ChatMessageSent(message, state.currentChannel));
        } else {
          chatRepo.sendChatMessage(mediaForChannel, messageRow,
              totalNumberOfMessages: state.currentChannelThread.length);
        }
        print("delete upload box now ${uploadBox.uniqueId}");
        await messageStore.deleteMessage(uploadBox.uniqueId.toString());
      } // Message is empty
    } // upload status is end
  }

  void dispose() {
    _currentUserStreamChatBloc?.cancel();
    _chatRepoStreamChatBloc?.cancel();
    _envelopStreamChatBloc?.cancel();
    super.close();
  }

  void _onEndChat(EndChat event, Emitter<ChatState> emit) async {
    if (!(_envelopStreamChatBloc?.isPaused ?? true)) {
      _envelopStreamChatBloc?.pause();
      _currentUserStreamChatBloc?.pause();
      _chatRepoStreamChatBloc?.pause();
    }

    chatRepo.endChat(state.currentChannel.channelName);
    emit(
      state.copyWith(
        status: ChatStatus.endChat,
        currentMessage: "",
      ),
    );
  }

  void _onClearHistory(ClearHistory event, Emitter<ChatState> emit) async {
    await messageStore.clearLastTenMessages(state.currentChannel.channelName);
    // await chatRepo.clearHistory(state.currentChannel.channelName);
    // emit(
    //   state.copyWith(
    //     status: ChatStatus.initial,
    //     currentMessage: "",
    //     currentChannelThread: [],
    //   ),
    // );
  }

  // Event called when user clicked on channel Row in channel list,
  // Reset Previous channel and set new channel
  void _onResetChat(ResetChat event, Emitter<ChatState> emit) {
    // if (!(_envelopStreamChatBloc?.isPaused ?? true)) {
    //   print("Reset Chat");
    //   _envelopStreamChatBloc?.pause();
    // }

    emit(
      state.copyWith(
          status: ChatStatus.movedToChannel,
          currentMessage: "",
          currentChannelThread: [],
          currentChannel: ChatChannel.empty,
          replyTo: "",
          replyToChannelId: ""),
    );
  }

  void _onResetTypingBoxPlaceholder(
      ResetTypingBoxPlaceholder event, Emitter<ChatState> emit) {
    return emit(state.copyWith(disableTypingMessage: ""));
  }

  void _onResetDisableTypingMessage(
      ResetDisableTypingMessage event, Emitter<ChatState> emit) {
    emit(state.copyWith(
        status: ChatStatus.movedToChannel,
        disableTypingMessage: "",
        replyTo: "",
        replyToChannelId: ""));
  }

  // just empty current channel thread
  void _onResetCurrentChannelThread(
      ResetCurrentChannelThread event, Emitter<ChatState> emit) {
    add(SignalSent(
      currentChannel: state.currentChannel,
      signalType: signalType.indexOf('typingOff').toString(),
    ));
    return emit(
      state.copyWith(
          status: ChatStatus.movedToChannel,
          currentMessage: "",
          currentChannelThread: [],
          currentChannel: const ChatChannel(
              channelName: "",
              lastMessageRow: MessageRow.empty,
              lastMessageTime: "",
              chatUser: ChatUser.empty,
              chatToUser: [],
              channelId: "",
              unreadMessageCount: ""),
          replyTo: "",
          replyToChannelId: "",
          disableTypingMessage: ""),
    );
  }

  // Fetch Chat For Paginagition
  void _onChatFetched(ChatFetched event, Emitter<ChatState> emit) async {
    if (state.hasReachedMin == true || state.currentChannelThread.isEmpty) {
      print("hasReachedMin = ${state.hasReachedMin}");
      return;
    }

    dynamic validateTyping = state.validateEnableTyping(
      chatThread: state.currentChannelThread,
      validateCurrentChannel: state.currentChannel,
    );

    if (state.disableTypingMessage.isNotEmpty) {
      emit(state.copyWith(status: ChatStatus.loadinghistory));
    } else {
      emit(
        state.copyWith(
            status: ChatStatus.loadinghistory,
            disableTypingMessage: validateTyping),
      );
    }

    List<MessageRow> chatHistory = [];
    List<ChatUser> toUsers = state.currentChannel.chatToUser;

    MessageRow currentFirstMessage = state.currentChannelThread.first;
    String currentFirstMessageTimeStamp = currentFirstMessage.timeStamp;

    dynamic getHistory = await chatRepo.getStoredChatHistory(
        state.currentChannel, currentFirstMessageTimeStamp, toUsers);

    if (getHistory['chatHistory'].toString() == '[]') {
      return emit(state.copyWith(
          status: ChatStatus.started,
          hasReachedMin: true,
          disableTypingMessage: validateTyping));
    } else {
      chatHistory = getHistory['chatHistory'];
      toUsers = getHistory['toUsers'];
    }
    emit(state.copyWith(
        status: ChatStatus.started,
        currentChannelThread: (chatHistory.isNotEmpty &&
                state.currentChannelThread.isNotEmpty &&
                chatHistory.first.channelName ==
                    state.currentChannelThread.first.channelName)
            ? [...chatHistory, ...state.currentChannelThread]
            : [...state.currentChannelThread],
        toUsers: [
          ...{...state.toUsers, ...toUsers}
        ],
        hasReachedMin: false,
        disableTypingMessage: validateTyping));
  }

  // send new signal
  _onSignalSent(SignalSent event, Emitter<ChatState> emit) async {
    String signalTypeValue = signalType[int.parse(event.signalType.toString())];

    if (int.parse(event.signalType.toString()) <= 1) {
      // Only signal Typing On and Off
      chatRepo.sendChatSignal(
          event.currentChannel, event.signalType.toString());
    } else {
      // Following condition needs database updates
      if (signalTypeValue == "blocked") {
        emit(state.copyWith(
          status: ChatStatus.chatClosed,
          currentChannel: state.currentChannel.copyWith(chatFlag: '2'),
        ));
        dynamic getUpdatedChannel = await chatRepo.sendChatSignal(
            event.currentChannel, event.signalType.toString());
        dynamic updatedChannel = getUpdatedChannel['channel'];
        return emit(state.copyWith(
          status: ChatStatus.sent,
          currentChannel: state.currentChannel.copyWith(
              chatFlag: '2', channelData: updatedChannel['channelData']),
          disableTypingMessage: "chat_section.lbl_chat_blocked_byYou".tr(),
        ));
      }

      if (signalTypeValue == "unblock") {
        emit(state.copyWith(
          status: ChatStatus.chatClosed,
          currentChannel: state.currentChannel.copyWith(chatFlag: '1'),
        ));
        dynamic getChannelDetails = await chatRepo.sendChatSignal(
            event.currentChannel, event.signalType.toString());

        dynamic getChannelData = getChannelDetails['channel'];

        ChatUser chatToUser = await chatRepo.getChatUser(
            userId: getChannelData['toUserId'].toString());

        ChatChannel currentUpdatedChanel = ChatChannel(
            chatFlag: '1',
            channelName: getChannelData['friendlyName'],
            lastMessageRow: MessageRow.empty,
            lastMessageTime: (getChannelData['timetoken']).toString(),
            chatUser: chatUser,
            chatToUser: [chatToUser],
            channelId: getChannelData['id'].toString(),
            channelData: getChannelData['channelData'],
            unreadMessageCount: '1');

        // TO DO: Start Check this on priority
        String enableTypeingCheck = state.validateEnableTyping(
            chatThread: state.currentChannelThread,
            validateCurrentChannel: currentUpdatedChanel);
        // TO DO: End Check this on priority

        return emit(state.copyWith(
          status: ChatStatus.sent,
          currentChannel: currentUpdatedChanel,
          disableTypingMessage: enableTypeingCheck,
        ));
      }

      if (signalTypeValue == "leaveChat") {
        emit(state.copyWith(
          status: ChatStatus.chatClosed,
          currentChannel: state.currentChannel.copyWith(chatFlag: '2'),
        ));
        dynamic getUpdatedChannel = await chatRepo.sendChatSignal(
            event.currentChannel, event.signalType.toString());
        dynamic updatedChannel = getUpdatedChannel['channel'];
        return emit(state.copyWith(
          status: ChatStatus.sent,
          currentChannel: state.currentChannel.copyWith(
              chatFlag: updatedChannel['chatFlag'].toString(),
              channelData: updatedChannel['channelData']),
          disableTypingMessage: "chat_section.lbl_you_left_the_chat".tr(),
        ));
      }
    }
  }

  // on new signal received
  _onSignalReceived(SignalReceived event, Emitter<ChatState> emit) async {
    dynamic signalContents = jsonDecode(event.message);

    int signalTypeIndex = int.parse(signalContents["signalType"] == null
        ? '1'
        : signalContents["signalType"].toString());
    String signalTypeValue = signalType[signalTypeIndex];
    String senderUserId = event.senderUserId;
    String lblBlockedBy = "chat_section.lbl_you_blocked_by".tr();
    String lblLeftchat = "chat_section.lbl_left_chat".tr();

    if (signalTypeValue == "blocked") {
      ChatUser senderUser = await chatRepo.getChatUser(userId: senderUserId);
      emit(state.copyWith(
        status: ChatStatus.chatClosed,
        currentChannel: state.currentChannel.copyWith(chatFlag: '2'),
        disableTypingMessage: "$lblBlockedBy ${senderUser.username}",
      ));
      dynamic getChannelDetails =
          await chatRepo.getChannelDetailsById(event.channelName);

      dynamic getChannelData = getChannelDetails['channel'];

      return emit(state.copyWith(
          status: ChatStatus.updateChatFlag,
          currentChannel: state.currentChannel.copyWith(
              chatFlag: '2', channelData: getChannelData['channelData'])));
    }

    if (signalTypeValue == "unblock") {
      emit(state.copyWith(
        status: ChatStatus.chatClosed,
        currentChannel: state.currentChannel.copyWith(chatFlag: '1'),
      ));

      dynamic getChannelDetails =
          await chatRepo.getChannelDetailsById(event.channelName);

      dynamic getChannelData = getChannelDetails['channel'];

      ChatChannel currentUpdatedChanel = state.currentChannel
          .copyWith(chatFlag: '1', channelData: getChannelData['channelData']);

      String enableTypeingCheck = state.validateEnableTyping(
          chatThread: state.currentChannelThread,
          validateCurrentChannel: currentUpdatedChanel);

      return emit(state.copyWith(
          status: ChatStatus.updateChatFlag,
          currentChannel: currentUpdatedChanel,
          disableTypingMessage: enableTypeingCheck));
    }

    if (signalTypeValue == "leaveChat") {
      ChatUser senderUser = await chatRepo.getChatUser(userId: senderUserId);
      emit(state.copyWith(
        status: ChatStatus.chatClosed,
        currentChannel: state.currentChannel.copyWith(chatFlag: '2'),
        disableTypingMessage: "${senderUser.username} $lblLeftchat",
      ));
      dynamic getChannelDetails =
          await chatRepo.getChannelDetailsById(event.channelName);

      dynamic getChannelData = getChannelDetails['channel'];

      ChatChannel currentUpdatedChanel = state.currentChannel
          .copyWith(chatFlag: '2', channelData: getChannelData['channelData']);

      String enableTypeingCheck = state.validateEnableTyping(
          chatThread: state.currentChannelThread,
          validateCurrentChannel: currentUpdatedChanel);

      return emit(
        state.copyWith(
          status: ChatStatus.updateChatFlag,
          disableTypingMessage: enableTypeingCheck,
          currentChannel: currentUpdatedChanel,
        ),
      );
    }

    // TO DO: Remove previous event and handle these event here
    if (signalTypeValue == "typingOn") {
      ChatUser senderUser = await chatRepo.getChatUser(userId: senderUserId);

      return emit(state.copyWith(
        status: ChatStatus.typingOn,
        typingIndicatorText: senderUser.username,
      ));
    }

    if (signalTypeValue == "typingOff") {
      return emit(state.copyWith(
        status: ChatStatus.typingOff,
        typingIndicatorText: "",
      ));
    }
  }

  // On new message received
  _onChatMessageReceived(
      ChatMessageReceived event, Emitter<ChatState> emit) async {
    dynamic timetoken = event.timetoken;

    emit(state.copyWith(
      status: ChatStatus.receiving,
    ));
    Map<String, dynamic> messageContents = jsonDecode(event.message);
    // Message received from User
    String senderUserId = event.senderUserId;
    String messageText = messageContents["text"];

    dynamic decodedMessageText = jsonDecode(messageText);
    dynamic decodedMessageData = jsonDecode(decodedMessageText['data']);

    decodedMessageData['timeStamp'] = event.timetoken.toString();

    if (decodedMessageData["replyToMessageId"] != null) {
      decodedMessageText = await chatRepo.getUpdatedMessageData(
          decodedMessageText, state.toUsers);
    }
    ChatChannel currentChannel = state.currentChannel;
    List<ChatUser> chatUsers = [];

    ChatUser senderUser = ChatUser.empty;
    if (senderUserId != state.currentUser.userId) {
      senderUser = state.toUsers.firstWhere(
          (element) => element.userId == senderUserId,
          orElse: () => ChatUser.empty);

      if (senderUser == ChatUser.empty) {
        senderUser = await chatRepo.getChatUser(userId: senderUserId);
        // Add If you found new users no in the list
        chatUsers.add(senderUser);
      }
    } else {
      // Message received from Current User
      // mulitple device open with same channel Screen.
      senderUser = state.currentUser;
    }

    String cardType = decodedMessageText['cardType'];

    String generateMessageId =
        "${senderUser.userId}-${currentChannel.channelId}-$timetoken";

    MessageRow recievedMessageRow = MessageRow(
      messageId: generateMessageId,
      channelName: event.channelName.toString(),
      chatUser: senderUser,
      message: Message(
        userId: senderUser.userId,
        channelName: event.channelName.toString(),
        content: MessageContent(
            cardType: cardType,
            data: decodedMessageText['data'],
            timeStamp: timetoken.toString()),
        timetoken: timetoken.toString(),
      ),
      timeStamp: timetoken.toString(),
    );

    currentChannel = state.currentChannel.copyWith(
      lastVisitTime: app_instance.utility.getUnixTimeStampInPubNubPrecision(),
      lastMessageRow: recievedMessageRow,
      lastMessageTime: timetoken,
      totalNumberOfMessages: state.currentChannel.totalNumberOfMessages + 1,
    );

    List<MessageRow> currentChannelThread = [];
    if (event.channelName == state.currentChannel.channelName) {
      emit(state.copyWith(
        currentChannel: currentChannel,
        status: ChatStatus.typingOff,
        typingIndicatorText: "",
      ));

      bool addMessage = true;
      int checkLastFiveOnly = 0;
      for (var element in state.currentChannelThread) {
        checkLastFiveOnly++;
        if (element.message.content!.timeStamp ==
            recievedMessageRow.timeStamp) {
          addMessage = false;
        }
        if (checkLastFiveOnly > 5) {
          break;
        }
      }

      if (addMessage == true) {
        currentChannelThread = [
          ...state.currentChannelThread,
          ...[recievedMessageRow]
        ];
      } else {
        currentChannelThread = [...state.currentChannelThread];
      }

      // currentChannelThread.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

      // Check if user able to send another messages
      String enableTypeingCheck = state.validateEnableTyping(
          chatThread: currentChannelThread,
          validateCurrentChannel: currentChannel);

      List<ChatUser> chatUserSet = (chatUsers.isNotEmpty)
          ? [...chatUsers, ...state.toUsers]
          : state.toUsers;
      emit(state.copyWith(
        currentChannel: currentChannel,
        toUsers: [
          ...{...chatUserSet}
        ],
        currentChannelThread: currentChannelThread,
        disableTypingMessage: enableTypeingCheck,
        status: ChatStatus.threadUpdated,
      ));

      if (addMessage == true) {
        // ** Save to Isar Message - Users  */
        MessageIsar saveMessage = MessageIsar();
        saveMessage.id = recievedMessageRow.messageId;
        saveMessage.channelName = recievedMessageRow.channelName;
        saveMessage.messageFromUserId =
            int.parse(recievedMessageRow.chatUser.userId.toString());
        saveMessage.message = recievedMessageRow.toString();
        saveMessage.timeStamp =
            int.parse(recievedMessageRow.timeStamp.toString());
        await messageStore.saveMessage(saveMessage);
        // ** Save to Isar Message - Users  */
      }

      if (recievedMessageRow.message.content!.cardType == "URL") {
        String messageId =
            "${recievedMessageRow.message.userId}-${currentChannel.channelId}-${recievedMessageRow.message.timetoken}";
        Future.delayed(const Duration(seconds: 6), () {
          add(UpdateMessage(
              notificationData: '',
              notificationType: 'updateMessageNotification',
              messageId: messageId));
        });
      }
    }
  }

  void _onValidateMessaging(
      ValidateMessaging event, Emitter<ChatState> emit) async {
    String validateMessage = state.validateEnableTyping(
        chatThread: state.currentChannelThread,
        validateCurrentChannel: state.currentChannel);
    emit(state.copyWith(
        status: (validateMessage.isEmpty)
            ? ChatStatus.started
            : ChatStatus.typingOff,
        disableTypingMessage: validateMessage));
  }

  // Message Box Related Events
  // Message Sent
  void _onChatMessageUpdated(
      ChatMessageUpdated event, Emitter<ChatState> emit) async {
    if (event.currentMessage.length == 1) {
      add(SignalSent(
        currentChannel: state.currentChannel,
        signalType: signalType.indexOf('typingOn').toString(),
      ));
      // This event replaced with SignalSent
      // add(TypingOn());
    }

    emit(state.copyWith(
      currentMessage: event.currentMessage,
      status: ChatStatus.typingOn,
    ));
  }

  _onUpdateCurrentUser(UpdateCurrentUser event, Emitter<ChatState> emit) async {
    ChatUser currentUser = await chatRepo.getChatUser(userId: event.userId);
    emit(state.copyWith(
        status: ChatStatus.threadUpdated, currentUser: currentUser));
  }

  // Sent Message
  _onChatMessageSent(ChatMessageSent event, Emitter<ChatState> emit) async {
    String messageTime =
        app_instance.utility.getUnixTimeStampInPubNubPrecision();

    ChatChannel currentChannel =
        state.currentChannel.copyWith(lastVisitTime: messageTime);

    emit(state.copyWith(
      currentChannel: currentChannel,
      status: ChatStatus.sending,
      replyTo: "",
      replyToChannelId: "",
    ));

    if (event.currentMessage != MessageContent.empty) {
      // Show in the current chat windows
      MessageContent messageContent =
          MessageContent.fromJson(jsonDecode(event.currentMessage.toString()));
      String cardType = messageContent.cardType.toString();
      dynamic messageData = messageContent.data;

      /*
      *
      *  Check if Current Channel flag is 0, mean channel not initialized
      *  Send Notification to member of the channel 
      *  Send First Message as Request Details as member of the channel
      *
      */
      if (event.currentChannel.chatFlag == "0") {
        dynamic decodedChannelData =
            jsonDecode(event.currentChannel.channelData.toString());
        emit(state.copyWith(
          status: ChatStatus.updateChatFlag,
          currentChannel: state.currentChannel.copyWith(
            chatFlag: "1",
          ),
        ));
        Map<String, String> notificationMessageData;
        if ((decodedChannelData['type'] == "request_prop")) {
          notificationMessageData = {
            'text': 'newChannel',
            'channelId': event.currentChannel.channelId,
            'firstMessage': state.currentChannelThread.isNotEmpty
                ? state.currentChannelThread.first.message.toString()
                : "",
            'newCardType': (decodedChannelData['type'] == "request_prop")
                ? 'NewChannelForRequest'
                : 'NewChannelForPrivateChat'
          };
        } else {
          notificationMessageData = {
            'text': 'newChannel',
            'channelId': event.currentChannel.channelId,
            'newCardType': 'NewChannelForPrivateChat'
          };
        }

        dynamic notificationMessage = MessageContent(
          cardType: "userNotification",
          timeStamp: messageTime,
          data: jsonEncode(notificationMessageData),
        );

        // TO DO
        // Make sure you sending message as notification need to address latter -
        // no need to insert into history
        chatRepo.sendMessage(
            "my-channel-${event.currentChannel.chatToUser.first.userId}",
            jsonEncode(notificationMessage));
        // Update Channel Flag on Server
        app_instance.itemApiProvider
            .updateChannelFlag(event.currentChannel.channelId);
        emit(state.copyWith(
          status: ChatStatus.started,
        ));

        Future.delayed(const Duration(seconds: 3));
      }

      List<MessageRow> chatThread = [];

      String pubNubServerTime = await chatRepo.getPServerTime();
      String messageTempId =
          '${state.currentUser.userId}-${currentChannel.channelId}-$pubNubServerTime';

      MessageRow lastMessageRow = MessageRow(
        messageId: messageTempId,
        channelName: event.currentChannel.channelName,
        message: Message(
          userId: state.currentUser.userId,
          channelName: event.currentChannel.channelName,
          timetoken: pubNubServerTime,
          content: MessageContent(
            cardType: cardType,
            data: event.currentMessage.data,
            timeStamp: pubNubServerTime,
          ),
        ),
        timeStamp: pubNubServerTime,
        chatUser: state.currentUser,
      );

      if (int.parse(state.currentChannel.channelId) > 2) {
        if (cardType == "text") {
          if (messageData['text'].length > 0) {
            chatThread = [
              ...state.currentChannelThread,
              ...[lastMessageRow]
            ];
          }
        } else {
          chatThread = [
            ...state.currentChannelThread,
            ...[lastMessageRow]
          ];
        }
      } else {
        chatThread = [...state.currentChannelThread];
      }

      // Check if user able to send  messages
      String enableTypingCheck = state.validateEnableTyping(
        chatThread: chatThread,
        validateCurrentChannel: currentChannel,
        maxMessageLength:
            int.parse(dotenv.env['MAX_MESSAGE_PAUSE'].toString()) + 1,
      );

      if (enableTypingCheck.isNotEmpty) {
        add(SignalSent(
          currentChannel: state.currentChannel,
          signalType: signalType.indexOf('typingOff').toString(),
        ));
        return emit(state.copyWith(
          disableTypingMessage: enableTypingCheck,
          status: ChatStatus.paused,
        ));
      }
      chatThread = [];
      String messageSentTime = chatRepo.getPubnubServerTime();
      String messageId = '';
      if (cardType == "text" || cardType == "URL") {
        // Publish Text Message
        if (messageData['text'].length > 0) {
          messageSentTime = await chatRepo.sendChatMessage(
              event.currentChannel, lastMessageRow,
              replyTo: event.replyTo,
              totalNumberOfMessages: state.currentChannelThread.length);
        }
        messageId =
            '${state.currentUser.userId}-${currentChannel.channelId}-$messageSentTime';
      } else {
        messageSentTime = await chatRepo.sendChatMessage(
            event.currentChannel, lastMessageRow,
            replyTo: event.replyTo,
            storeInDB: (!cardTypePlaceholderList.contains(cardType)),
            messageId: event.messageId.toString(),
            totalNumberOfMessages: state.currentChannelThread.length);
        messageId = event.messageId.toString();
      }

      List<MessageRow> currentChannelThread = state.currentChannelThread;

      Message currentMessage = Message(
        channelName: event.currentChannel.channelName,
        timetoken: messageSentTime,
        userId: state.currentUser.userId,
        content: MessageContent(
          cardType: cardType,
          data: event.currentMessage.data,
          timeStamp: messageSentTime,
        ),
      );

      lastMessageRow = MessageRow(
        messageId: messageId,
        channelName: event.currentChannel.channelName,
        message: currentMessage,
        timeStamp: messageSentTime,
        chatUser: state.currentUser,
      );

      if (cardType == "text") {
        if (messageData['text'].length > 0) {
          currentChannelThread = [
            ...state.currentChannelThread,
            ...[lastMessageRow]
          ];
        }
      } else {
        currentChannelThread = [
          ...state.currentChannelThread,
          ...[lastMessageRow]
        ];
      }

      // currentChannelThread.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

      // Check if user able to send  messages
      String enableTypeingCheckAfterSent = state.validateEnableTyping(
          chatThread: currentChannelThread,
          validateCurrentChannel: currentChannel);

      if (enableTypingCheck.isNotEmpty) {
        add(SignalSent(
          currentChannel: state.currentChannel,
          signalType: signalType.indexOf('typingOff').toString(),
        ));
      }

      ChatChannel chatChannel = ChatChannel.empty;

      chatChannel = state.currentChannel.copyWith(
        chatFlag: (state.currentChannel.channelId == "1" ||
                state.currentChannel.channelId == "2")
            ? "-1"
            : state.currentChannel.chatFlag,
        lastVisitTime: messageSentTime,
        lastMessageTime: messageSentTime,
        lastMessageSentTime: messageSentTime,
        lastMessageRow: lastMessageRow,
        totalNumberOfMessages: state.currentChannel.totalNumberOfMessages + 1,
      );

      emit(state.copyWith(
        disableTypingMessage: enableTypeingCheckAfterSent,
        currentChannelThread: currentChannelThread,
        currentChannel: chatChannel,
        currentMessage: "",
        status: enableTypeingCheckAfterSent.isNotEmpty
            ? ChatStatus.typingOff
            : ChatStatus.sent,
      ));
      if (lastMessageRow.message.content!.cardType == "URL") {
        String messageId =
            "${lastMessageRow.message.userId}-${state.currentChannel.channelId}-${lastMessageRow.message.timetoken}";
        Future.delayed(const Duration(seconds: 6), () {
          add(UpdateMessage(
              notificationData: '',
              notificationType: 'updateMessageNotification',
              messageId: messageId));
        });
      }

      await updateLocalStorage(chatChannel);
    }
  }

  updateLocalStorage(ChatChannel currentActiveChannel) async {
    if (currentActiveChannel != null &&
        currentActiveChannel.channelId.isNotEmpty &&
        currentActiveChannel != ChatChannel.empty) {
      channel_store.Channel channelStore = channel_store.Channel();
      // ** Save to Isar Channel - Users - First Message */
      ChannelIsar saveChannel = ChannelIsar();
      List<int> chatToUsers = [];
      if (int.parse(currentActiveChannel.channelId) > 2) {
        for (var element in currentActiveChannel.chatToUser) {
          try {
            if (element.userId != 'null') {
              chatToUsers.add(int.parse(element.userId.toString()));
            }
          } catch (err) {
            print(chatUser.toString());
            print("error is ------- $err");
            print(currentActiveChannel);
          }
        }
      }

      String lastMessageTime =
          currentActiveChannel.lastMessageRow == MessageRow.empty
              ? "0"
              : currentActiveChannel.lastMessageRow.timeStamp;
      saveChannel.id = int.parse(currentActiveChannel.channelId.toString());
      saveChannel.channelName = currentActiveChannel.channelName;
      saveChannel.lastMessageRow =
          currentActiveChannel.lastMessageRow.toString();
      saveChannel.lastMessageTime = int.parse(lastMessageTime);
      saveChannel.unreadMessageCount = currentActiveChannel.unreadMessageCount;
      saveChannel.chatFlag = currentActiveChannel.chatFlag;
      saveChannel.chatToUserId = chatToUsers;
      saveChannel.chatUserId = int.parse(currentActiveChannel.chatUser.userId);
      saveChannel.channelData = currentActiveChannel.channelData;
      saveChannel.typingIndicator = currentActiveChannel.typingIndicator;
      saveChannel.typingIndicatorStartTime =
          currentActiveChannel.typingIndicatorStartTime;
      saveChannel.lastVisitTime = int.parse(lastMessageTime);
      saveChannel.lastMessageSentTime = int.parse(lastMessageTime);
      saveChannel.totalNumberOfMessages =
          currentActiveChannel.totalNumberOfMessages;
      await channelStore.saveChannel(saveChannel);
      // ** Save to Isar Channel - Users - First Message */
    }
  }

  // Generate static channel name
  String generateStaticChannelName(
      {required String toUserId, required String propRequestId}) {
    String channelName = '';
    if (int.parse(toUserId) > int.parse(chatUser.userId)) {
      channelName = 'user-${chatUser.userId}-user-$toUserId';
    } else {
      channelName = 'user-$toUserId-user-${chatUser.userId.toString()}';
    }

    // Property Channel Created from Server Side
    // Only Private channels are created here from client side
    if (propRequestId != '') {
      channelName =
          '$channelName-prop-$propRequestId-${dotenv.env['PUB_NUB_CHANNEL_SLUG']}';
    } else {
      channelName =
          '$channelName-private-${dotenv.env['PUB_NUB_CHANNEL_SLUG']}';
    }

    return channelName;
  }

  // Generate Channel Name
  Future<ChatChannel> generateChannelName(
      String toUserId, String propRequestId) async {
    String channelName = generateStaticChannelName(
      toUserId: toUserId,
      propRequestId: propRequestId,
    );

    // Code moved to generateStaticChannelName
    // if (int.parse(toUserId) > int.parse(chatUser.userId)) {
    //   channelName = 'user-${chatUser.userId}-user-$toUserId';
    // } else {
    //   channelName = 'user-$toUserId-user-${chatUser.userId.toString()}';
    // }
    // if (propRequestId != '') {
    //   channelName =
    //       '$channelName-prop-$propRequestId-${dotenv.env['PUB_NUB_CHANNEL_SLUG']}';
    // } else {
    //   channelName =
    //       '$channelName-private-${dotenv.env['PUB_NUB_CHANNEL_SLUG']}';
    // }

    dynamic getNewChannel = await chatRepo.createChannel(
        from: chatUser.userId.toString(),
        to: toUserId,
        friendlyName: channelName,
        propertyRequestId: propRequestId);

    ChatUser chatToUser = state.toUsers.firstWhere(
        (element) => element.userId == toUserId,
        orElse: () => ChatUser.empty);

    if (chatToUser == ChatUser.empty) {
      chatToUser = await chatRepo.getChatUser(userId: toUserId);
    }

    dynamic getNewChannelData = jsonDecode(getNewChannel["channel"]);
    ChatChannel sendChannelBack = ChatChannel(
      channelId: getNewChannelData["id"].toString(),
      channelName: getNewChannelData["friendlyName"].toString(),
      chatUser: state.currentUser,
      chatToUser: [chatToUser],
      chatFlag: getNewChannelData["chatFlag"].toString(),
      channelData: getNewChannelData["channelData"],
      lastMessageRow: MessageRow.empty,
      lastMessageTime: app_instance.utility.getUnixTimeStampInPubNubPrecision(),
      unreadMessageCount: "0",
    );

    return sendChannelBack;
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      return ChatState.fromJson(json);
    } catch (e, stacktrace) {
      print('''Error: $e \n StackTrace: $stacktrace''');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    try {
      return state.toJson();
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
      return null;
    }
  }
}

@override
Stream<ChatState> transformEvents(events, next) {
  return events.switchMap(next);
}
