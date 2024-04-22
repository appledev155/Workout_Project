import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  SavedBloc() : super(SavedState()) {
    on<SavedFetched>(_onSavedFetch);
  }

  Future<void> _onSavedFetch(
      SavedFetched event, Emitter<SavedState> emit) async {
    try {
      String? rec = await app_instance.storage.read(key: 'searchSavedLists');
      List<Object> itemsJson = [];
      List<dynamic> items;
      if (rec != null && rec != '{"data":[]}') {
        var tagsJson = jsonDecode(rec)['data'];
        itemsJson = tagsJson != null ? List.from(tagsJson.reversed) : [];

        items = itemsJson.map((rawPost) {
          return jsonDecode(rawPost.toString());
        }).toList();
      } else {
        items = [];
      }

      String? recIds = await app_instance.storage.read(key: 'searchIds');
      List recIdsList = [];
      if (recIds != null) {
        var tagsJson = jsonDecode(recIds)['data'];
        List? searchIdsList =
            tagsJson != null ? List.from(tagsJson.reversed) : null;
        if (searchIdsList != null) {
          recIdsList = searchIdsList;
        }
      }
      return emit(state.copyWith(
          items: items,
          recIdsList: recIdsList,
          page: 1,
          hasReachedMax: true,
          saveStatus: SaveStatus.success));
      /*  yield SavedSuccess(
              items: items,
              recIdsList: recIdsList,
              page: 1,
              hasReachedMax: true); */
    } catch (e, _) {
      emit(state.copyWith(saveStatus: SaveStatus.failure));
      print(e);
      print(_);
      print("Exception");
    }
  }
}
