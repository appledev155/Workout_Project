part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChannelsLoaded extends ChatEvent {
  const ChannelsLoaded();
}

class ResetChat extends ChatEvent {
  const ResetChat();
}

class ShowTypingIndicator extends ChatEvent {
  const ShowTypingIndicator(this.message, this.channelName, this.senderId);
  final String message;
  final String channelName;
  final String senderId;

  @override
  List<Object> get props => [message, channelName, senderId];
}

class ClearHistory extends ChatEvent {
  const ClearHistory({required this.currentChannel});
  final ChatChannel currentChannel;

  @override
  List<Object> get props => [currentChannel];
}

class ChatInitiated extends ChatEvent {
  const ChatInitiated({
    required this.chatToUser,
    required this.currentChannel,
    this.propRequestId,
    this.replyTo,
    this.replyToChannelId,
  });
  final List<ChatUser> chatToUser;
  final String? propRequestId;
  final ChatChannel currentChannel;
  final String? replyTo;
  final String? replyToChannelId;

  @override
  List<Object> get props => [
        chatToUser,
        currentChannel,
        currentChannel,
        propRequestId!,
        replyTo!,
        replyToChannelId!
      ];
}

class ChatFetched extends ChatEvent {}

class CreateChannel extends ChatEvent {
  const CreateChannel(this.chatToUser, this.propRequestId);
  final ChatUser chatToUser;
  final String propRequestId;
  @override
  List<Object> get props => [];
}

class ChatStart extends ChatEvent {
  const ChatStart(this.message, this.chatThread);
  final List<MessageRow> message;
  final List<MessageRow> chatThread;

  @override
  List<Object> get props => [message, chatThread];
}

class ChatMessageUpdated extends ChatEvent {
  final String currentMessage;

  const ChatMessageUpdated(this.currentMessage);

  @override
  List<Object> get props => [currentMessage];
}

class ChatMessageReceived extends ChatEvent {
  const ChatMessageReceived(
      {required this.message,
      required this.channelName,
      required this.senderUserId,
      required this.timetoken});
  final String message;
  final String channelName;
  final String senderUserId;
  final String timetoken;

  @override
  List<Object> get props => [message, channelName, senderUserId];
}

class SignalReceived extends ChatEvent {
  const SignalReceived(
      {required this.message,
      required this.channelName,
      required this.senderUserId,
      required this.timetoken});
  final String message;
  final String channelName;
  final String senderUserId;
  final String timetoken;

  @override
  List<Object> get props => [message, channelName, senderUserId];
}

class SignalSent extends ChatEvent {
  const SignalSent({
    required this.signalType,
    required this.currentChannel,
    this.message,
    this.senderUserId,
    this.timetoken,
  });
  final String signalType;
  final ChatChannel currentChannel;
  final String? senderUserId;
  final String? message;
  final String? timetoken;

  @override
  List<Object> get props => [
        currentChannel,
        signalType,
      ];
}

class ChatMessageSent extends ChatEvent {
  const ChatMessageSent(this.currentMessage, this.currentChannel,
      {this.timeToken, this.storeInDB, this.messageId, this.replyTo = false});
  final MessageContent currentMessage;
  final ChatChannel currentChannel;
  final String? timeToken; // only for processing media
  final bool? storeInDB;
  final String? messageId;
  final bool replyTo;

  @override
  List<Object> get props => [
        currentMessage,
        currentChannel,
        storeInDB!,
        timeToken!,
        messageId!,
        replyTo
      ];
}

class GetEnvelope extends ChatEvent {
  const GetEnvelope(this.envelope);
  final Envelope envelope;

  @override
  List<Object> get props => [envelope];
}

class EndChat extends ChatEvent {
  const EndChat(this.channelName);
  final String channelName;

  @override
  List<Object> get props => [channelName];
}

class MediaShared extends ChatEvent {
  final UploadBox uploadBox;
  const MediaShared({required this.uploadBox});
}

class ResetDisableTypingMessage extends ChatEvent {}

class CheckTypingIndicatorValidate extends ChatEvent {
  final Timer timer;
  const CheckTypingIndicatorValidate({required this.timer});
}

class ValidateMessaging extends ChatEvent {}

class SyncMessages extends ChatEvent {}

class ResetTypingBoxPlaceholder extends ChatEvent {}

class ResetCurrentChannelThread extends ChatEvent {}

class UpdateMessage extends ChatEvent {
  final String notificationData;
  final String notificationType;
  final String? messageId;
  const UpdateMessage(
      {required this.notificationData,
      required this.notificationType,
      this.messageId});
}

class UpdateCurrentUser extends ChatEvent {
  final String userId;
  const UpdateCurrentUser({required this.userId});
}
