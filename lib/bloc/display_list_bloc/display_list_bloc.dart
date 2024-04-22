import 'dart:async';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/isar/home_lists/operation.dart' as home_list;
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:anytimeworkout/model/list_model.dart';
import 'package:darq/darq.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'display_list_event.dart';
part 'display_list_state.dart';

class DisplayListBloc extends Bloc<DisplayListEvent, DisplayListState> {
  DisplayListBloc() : super(DisplayListState()) {
    on<FetchIsarData>(_onFetchIsarData);
    on<DeleteListpage>(_onDeleteListpage);
  }

  home_list.HomeListOperation homelist = home_list.HomeListOperation();

  late IsarServices isarServices;

  FutureOr<void> _onFetchIsarData(
      FetchIsarData event, Emitter<DisplayListState> emit) async {
    emit(state.copyWith(displayListStatus: DisplayListStatus.initial));
    dynamic response = await homelist.getDataList();
    List<ListModel> listArray = [];
    for (var element in response) {
      listArray.add(ListModel(
          name: element.name,
          date: element.date,
          duration: element.duration,
          id: element.id,
          distance: element.distance,
          latitude: element.latitude,
          longitude: element.longitude));
    }
    emit(state.copyWith(
        displayListStatus: DisplayListStatus.success,
        listpostmodel: listArray.reverse().toList()));
  }

  _onDeleteListpage(
      DeleteListpage event, Emitter<DisplayListState> emit) async {
    emit(state.copyWith(displayListStatus: DisplayListStatus.deletelist));
    state.listpostmodel!
        .removeWhere((element) => element.id.toString() == event.id.toString());

    await homelist.deleteData(int.parse(event.id.toString()));

    Fluttertoast.showToast(
        msg: 'List Deleted successfully',
        toastLength: Toast.LENGTH_LONG,
        textColor: lightColor,
        backgroundColor: primaryColor,
        timeInSecForIosWeb: 2);
    emit(state.copyWith(
        displayListStatus: DisplayListStatus.success,
        listpostmodel: state.listpostmodel));
  }
}
