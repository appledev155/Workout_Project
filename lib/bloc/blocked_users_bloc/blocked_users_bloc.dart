import 'package:anytimeworkout/module/chat/repo/chat_repo.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:equatable/equatable.dart';

import '../current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/isar/channel/channel.dart' as channel_store;
import 'package:anytimeworkout/config.dart' as app_instance;

part 'blocked_users_event.dart';
part 'blocked_users_state.dart';

class BlockedUsersBloc extends Bloc<BlockedUsersEvent, BlockedUsersState> {
  late final CurrentUserBloc currentUserBloc;
  late ChatRepo chatRepo;
  channel_store.Channel channelStore = channel_store.Channel();

  BlockedUsersBloc() : super(const BlockedUsersState()) {
    on<BlockUnblockUser>(_onBlockUnblockUser);
    on<BlockedUsersFetched>(_onBlockedUsersFetched);
  }

  // Block and Unblock user
  Future<void> _onBlockUnblockUser(
      BlockUnblockUser event, Emitter<BlockedUsersState> emit) async {
    String channelId = event.channelId ?? "";
    app_instance.itemApiProvider
        .blockUser(event.userId, event.isBlockUnblock, channelId);
    emit(state.copyWith(status: BlockedUsersStatus.blocked));
  }

  Future<void> _onBlockedUsersFetched(
      BlockedUsersFetched event, Emitter<BlockedUsersState> emit) async {
    if (event.status == BlockedUsersStatus.initial) {
      emit(state.copyWith(
        status: event.status,
        hasReachedMax: false,
        blockedUsers: [],
      ));
    }

    if (state.hasReachedMax) return;

    try {
      if (state.status == BlockedUsersStatus.initial) {
        dynamic getBlockedUsersList =
            await app_instance.itemApiProvider.getBlockUsers();

        bool loadshow = false;
        if (getBlockedUsersList['blockUsers'].length < 10) loadshow = true;

        return emit(state.copyWith(
            status: BlockedUsersStatus.success,
            hasReachedMax: loadshow,
            blockedUsers: getBlockedUsersList['blockUsers']));
      }
    } catch (er) {
      print(er);
    }

    try {
      int startIndex = ((state.blockedUser.length - 2) / 10).round() + 1;

      dynamic getBlockedUsersList = await app_instance.itemApiProvider
          .getBlockUsers(pageNumber: startIndex);

      bool loadshow = false;
      if (getBlockedUsersList['blockUsers'] != null) {
        if (getBlockedUsersList['blockUsers'].length < 10) loadshow = true;
      } else {
        emit(state
            .copyWith(status: BlockedUsersStatus.success, blockedUsers: []));
      }

      (getBlockedUsersList.isEmpty)
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              status: BlockedUsersStatus.success,
              hasReachedMax: loadshow,
              blockedUsers: [
                  ...state.blockedUser,
                  ...getBlockedUsersList['blockUsers']
                ]));
    } catch (er, stacktrace) {
      emit(state.copyWith(status: BlockedUsersStatus.failure));
      print(er);
      print(stacktrace);
    }
  }
}
