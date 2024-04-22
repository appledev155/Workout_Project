part of 'upload_progress_bloc.dart';

class UploadProgressEvent extends Equatable {
  const UploadProgressEvent();

  @override
  List<Object> get props => [];
}

class MediaPicked extends UploadProgressEvent {
  final UploadBox? uploadBox;
  final ChatUser? chatUser;
  const MediaPicked({this.uploadBox, this.chatUser});
}

class ClearMedia extends UploadProgressEvent {
  const ClearMedia();
}
