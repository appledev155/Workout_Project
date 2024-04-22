part of 'channel_bloc.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object> get props => [];
}

class FetchFromStore extends ChannelEvent {
  final ChannelStatus? status;
  final String? lastSyncTimeStamp;
  const FetchFromStore({this.status, this.lastSyncTimeStamp});
}

class ChannelMessageReceived extends ChannelEvent {
  final String? message;
  final String? senderUserId;
  final String? channelName;
  final String? timetoken;
  const ChannelMessageReceived(
      {this.message, this.senderUserId, this.channelName, this.timetoken});
}

class UpdateChannelList extends ChannelEvent {
  final List<ChatChannel>? channelList;
  final bool? reversed;
  final ChannelStatus? status;
  final bool? createSubscription;
  const UpdateChannelList(
      {this.channelList, this.reversed, this.status, this.createSubscription});
}

class PrivateSubscribe extends ChannelEvent {
  final ChatChannel newChannel;
  const PrivateSubscribe({required this.newChannel});
}

class DeleteChannel extends ChannelEvent {
  final ChatChannel? chatChannel;
  const DeleteChannel({this.chatChannel});
}

class NewChannelInitiate extends ChannelEvent {
  final String? message;
  final String? userId;
  final String? channelName;
  const NewChannelInitiate({this.message, this.userId, this.channelName});
}

class MovedOnChatScreen extends ChannelEvent {
  final ChatChannel currentActiveChannel;
  final String connectionStatus;
  const MovedOnChatScreen(
      {required this.currentActiveChannel, required this.connectionStatus});
}

class MovedChannelScreen extends ChannelEvent {
  final ChatChannel? chatChannel;
  final List<ChatUser>? toUsers;
  const MovedChannelScreen({this.chatChannel, this.toUsers});
}

class SetCurrentActiveChannel extends ChannelEvent {
  final ChatChannel currentActiveChannel;
  const SetCurrentActiveChannel({required this.currentActiveChannel});
}

class ChannelResetState extends ChannelEvent {}

class ChannelIndicator extends ChannelEvent {
  final String channelName;
  final int currentSignal;
  final String userId;
  const ChannelIndicator(
      {required this.userId,
      required this.channelName,
      required this.currentSignal});
}

class NewRequestCreated extends ChannelEvent {
  final bool? selfNewRequest;
  const NewRequestCreated({this.selfNewRequest});
}

class UserProfileUpdate extends ChannelEvent {
  final String updatedProfileUserId;
  final String notificationType;
  const UserProfileUpdate(
      {required this.updatedProfileUserId, required this.notificationType});
}

class MessageUpdate extends ChannelEvent {
  final String notificationData;
  final String notificationType;
  const MessageUpdate(
      {required this.notificationData, required this.notificationType});
}

class DeleteChannels extends ChannelEvent {
  final String notificationData;
  final String notificationType;
  const DeleteChannels(
      {required this.notificationData, required this.notificationType});
}

class UserSignalSent extends ChannelEvent {
  const UserSignalSent({
    required this.signalType,
    required this.currentChannel,
    this.message,
    this.senderUserId,
    this.timetoken,
  });
  final String signalType;
  final dynamic currentChannel;
  final String? senderUserId;
  final String? message;
  final String? timetoken;

  @override
  List<Object> get props => [
        currentChannel,
        signalType,
      ];
}

class UserSignalReceived extends ChannelEvent {
  const UserSignalReceived(
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

class DeleteChannelsByRequestId extends ChannelEvent {
  final String requestId;
  const DeleteChannelsByRequestId({required this.requestId});
}

// clear channel and other data which is related to deleted user
class ClearDeletedUserData extends ChannelEvent {
  final String userId;
  const ClearDeletedUserData({required this.userId});
}

class ChannelSync extends ChannelEvent {
  final ChannelStatus status;
  final String? channelSyncTimeStamp;
  final String? chatSyncTimeStamp;
  const ChannelSync({
    required this.status,
    this.channelSyncTimeStamp,
    this.chatSyncTimeStamp,
  });
}

class UpdateSingleChannel extends ChannelEvent {
  final String channelName;
  const UpdateSingleChannel({required this.channelName});
}

class ResetUnreadChannelCount extends ChannelEvent {}

class ResumeEnvelopeStream extends ChannelEvent {}
