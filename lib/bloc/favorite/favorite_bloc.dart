import 'dart:async';

import '../../repository/item_api_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/item_model.dart';
import 'package:anytimeworkout/config.dart' as app_instance;
part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<FavoriteFetched>(_onFavoriteFetched);
    on<FavoriteRefresh>(_onFavoriteRefresh);
    on<ResetFavoriteState>(_onResetFavoriteState);
  }

  _onResetFavoriteState(ResetFavoriteState event, Emitter<FavoriteState> emit) {
    emit(state.copyWith(status: FavoriteStatus.updating));
    emit(state.copyWith(status: FavoriteStatus.sucess, items: []));
  }

  _onFavoriteFetched(FavoriteFetched event, Emitter<FavoriteState> emit) async {
    try {
      String? favIds = await app_instance.storage.read(key: 'favIds');

      Map<String, Object> jsonData = {
        'favIds': favIds.toString(),
      };

      if (favIds != null && favIds != '{"data":[]}') {
        final items =
            await app_instance.itemApiProvider.myFavoriteList(jsonData);

        emit(state.copyWith(
            status: FavoriteStatus.sucess,
            hasReachedMax: true,
            items: items,
            page: 1));
      } else {
        emit(state.copyWith(status: FavoriteStatus.failure));
      }
      return;
    } catch (e, _) {
      print(e);
      print(_);
      print('exception');
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  Future<void> _onFavoriteRefresh(
      FavoriteRefresh event, Emitter<FavoriteState> emit) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.initial));
    } catch (e, _) {
      print(e);
      print(_);
    }
  }
}
