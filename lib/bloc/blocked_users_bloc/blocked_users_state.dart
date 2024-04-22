part of 'blocked_users_bloc.dart';

enum BlockedUsersStatus { initial, success, failure, blocked }

class BlockedUsersState extends Equatable {
  final BlockedUsersStatus status;
  final List<dynamic> blockedUser;
  final bool hasReachedMax;
  final int page;

  const BlockedUsersState(
      {this.status = BlockedUsersStatus.initial,
      this.blockedUser = const [],
      this.hasReachedMax = false,
      this.page = 1});

  BlockedUsersState copyWith(
      {BlockedUsersStatus? status,
      List<dynamic>? blockedUsers,
      bool? hasReachedMax,
      int? page}) {
    BlockedUsersState blockedUsersState = BlockedUsersState(
        status: status ?? this.status,
        blockedUser: blockedUsers ?? blockedUser,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page);
    return blockedUsersState;
  }

  @override
  List<Object> get props => [status, blockedUser, hasReachedMax, page];
}
