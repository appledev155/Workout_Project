part of 'my_request_bloc.dart';

abstract class MyRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MyRequestFetched extends MyRequestEvent {
  final MyRequestStatus status;
  final bool? hasReachedMaxRequest;
  final bool? fromServer;
  MyRequestFetched(
      {required this.status,
      this.hasReachedMaxRequest,
      this.fromServer = false});
}

class RequestDelete extends MyRequestEvent {
  final RequestModel requestDetails;
  RequestDelete({required this.requestDetails});
}

class MyRequestResetState extends MyRequestEvent {}

class UpdateUserRequest extends MyRequestEvent {
  final String updateType;
  final int createdAt;
  final int updatedAt;
  final String serverId;
  UpdateUserRequest(
      {required this.updateType,
      required this.createdAt,
      required this.updatedAt,
      required this.serverId});
}

class UpdateZeroIdRequest extends MyRequestEvent {}

class AddNewRequest extends MyRequestEvent {
  final MyRequestStatus status;
  AddNewRequest({required this.status});
}

class SyncToServer extends MyRequestEvent {}
