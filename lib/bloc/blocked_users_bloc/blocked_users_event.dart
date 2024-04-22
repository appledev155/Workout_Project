part of 'blocked_users_bloc.dart';

abstract class BlockedUsersEvent extends Equatable {
  const BlockedUsersEvent();

  @override
  List<Object> get props => [];
}

class BlockUnblockUser extends BlockedUsersEvent {
  final String isBlockUnblock;
  final String userId;
  final String? channelId;
  const BlockUnblockUser(
      {required this.isBlockUnblock, required this.userId, this.channelId});
}

class BlockedUsersFetched extends BlockedUsersEvent {
  final BlockedUsersStatus? status;
  const BlockedUsersFetched({this.status});
}
