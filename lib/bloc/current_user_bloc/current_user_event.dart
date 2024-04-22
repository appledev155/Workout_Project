part of 'current_user_bloc.dart';

abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object> get props => [];
}

class IsAuthorized extends CurrentUserEvent {
  final UserModel loginInUser;
  const IsAuthorized(this.loginInUser);
}

class LogOutRequest extends CurrentUserEvent {
  const LogOutRequest();
}

class GetPushNotificatoinPermission extends CurrentUserEvent {
  const GetPushNotificatoinPermission();
}

class PubNubEvent extends CurrentUserEvent {
  final Envelope envelope;
  const PubNubEvent(this.envelope);
}

class UploadEvent extends CurrentUserEvent {
  final UploadBox uploadBox;
  const UploadEvent(this.uploadBox);
}

class NewEnvelopReceived extends CurrentUserEvent {
  final Envelope envelope;
  const NewEnvelopReceived(this.envelope);
}

class UpdateMessageCount extends CurrentUserEvent {
  final int? unreadMessageCount;
  const UpdateMessageCount(this.unreadMessageCount);
}

class UpdateProfile extends CurrentUserEvent {
  final bool deleteAccount;
  const UpdateProfile({this.deleteAccount = false});
}
