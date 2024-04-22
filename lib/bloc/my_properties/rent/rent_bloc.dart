import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/config/constant.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../model/item_model.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

part 'rent_event.dart';
part 'rent_state.dart';

class RentBloc extends Bloc<RentEvent, RentState> {
  RentBloc() : super(const RentState()) {
    on<RentFetched>(_onRentFetch);
    on<RentResetStateState>(_onRentReset);
    Constants.refresh.stream.listen((event) {
      add(RentFetched());
    });
  }

  Future<void> _onRentFetch(RentFetched event, Emitter<RentState> emit) async {
    try {
      String? userKey = await app_instance.storage.read(key: 'userKey');
      UserModel currentUser = await app_instance.utility.jwtUser();
      Map<String, Object> searchCond = {
        'buyrent_type': 'Rent',
        'user_id': userKey!,
      };

      if (state.rentStatus == RentStatus.initial) {
        Map<String, Object> jsonData = {
          'page': '1',
          'app_version': '1',
          'token': currentUser.token.toString(),
          'search_cond': json.encode(searchCond),
        };
        final itemsRent =
            await app_instance.itemApiProvider.mypropertiesList(jsonData);

        bool loadshow = false;
        if (itemsRent.length < 15) loadshow = true;
        emit(state.copyWith(
            itemsRent: itemsRent,
            pageRent: 1,
            hasReachedMaxRent: loadshow,
            rentStatus: RentStatus.success));
        /*        yield RentSuccess(
              itemsRent: itemsRent, pageRent: 1, hasReachedMaxRent: loadshow); */
        return;
      }
      if (state.rentStatus == RentStatus.success) {
        final nextPage = state.pageRent! + 1;

        Map<String, Object> jsonData = {
          'page': nextPage.toString(),
          'app_version': '1',
          'token': currentUser.token.toString(),
          'search_cond': json.encode(searchCond),
        };

        final itemsRent =
            await app_instance.itemApiProvider.mypropertiesList(jsonData);

        bool loadshow = false;
        if (itemsRent.length < 15) loadshow = true;
        (itemsRent.isEmpty)
            ? emit(state.copyWith(hasReachedMaxRent: true))
            : emit(state.copyWith(
                rentStatus: RentStatus.success,
                itemsRent: state.itemsRent! + itemsRent,
                pageRent: nextPage,
                hasReachedMaxRent: loadshow));
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }

  Future<void> _onRentReset(
      RentResetStateState event, Emitter<RentState> emit) async {
    try {
      emit(state.copyWith(rentStatus: RentStatus.initial));
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }
}
