import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/config/constant.dart';
import 'package:anytimeworkout/model/user_model.dart';

import '../../../model/item_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleBloc() : super(const SaleState()) {
    on<SaleFetched>(_fetchSaleData);
    on<SaleResetStateState>(_resetState);
    Constants.refresh.stream.listen((event) {
      add(SaleFetched());
    });
  }
  Future<void> _fetchSaleData(
      SaleFetched event, Emitter<SaleState> emit) async {
    try {
      final curSaleState = state;
      String? userKey = await app_instance.storage.read(key: 'userKey');
      UserModel currentUser = await app_instance.utility.jwtUser();

      Map<String, Object> searchCond = {
        'buyrent_type': 'Sell',
        'user_id': userKey!,
      };

      if (state.saleStatus == SaleStatus.initial) {
        Map<String, Object> jsonData = {
          'page': '1',
          'app_version': '1',
          'token': currentUser.token.toString(),
          'search_cond': json.encode(searchCond),
        };
        final itemsSale =
            await app_instance.itemApiProvider.mypropertiesList(jsonData);

        bool loadshow = false;
        if (itemsSale.length < 15) loadshow = true;
        emit(state.copyWith(
            itemsSale: itemsSale,
            saleStatus: SaleStatus.success,
            pageSale: 1,
            hasReachedMaxSale: loadshow));
        /*    yield SaleSuccess(
              itemsSale: itemsSale, pageSale: 1, hasReachedMaxSale: loadshow); */
        return;
      }

      if (state.saleStatus == SaleStatus.success) {
        final nextPage = curSaleState.pageSale! + 1;
        Map<String, Object> jsonData = {
          'page': nextPage.toString(),
          'app_version': '1',
          'token': currentUser.token.toString(),
          'search_cond': json.encode(searchCond),
        };
        final itemsSale =
            await app_instance.itemApiProvider.mypropertiesList(jsonData);

        bool loadshow = false;
        if (itemsSale.length < 15) loadshow = true;
        itemsSale.isEmpty
            ? emit(state.copyWith(hasReachedMaxSale: true))
            : emit(state.copyWith(
                itemsSale: curSaleState.itemsSale! + itemsSale,
                pageSale: nextPage,
                hasReachedMaxSale: loadshow,
                saleStatus: SaleStatus.success));
      }
    } catch (e, _) {
      emit(state.copyWith(saleStatus: SaleStatus.failure));
      print(e);
      print(_);
      print("Exception");
    }
  }

  Future<void> _resetState(
      SaleResetStateState event, Emitter<SaleState> emit) async {
    try {
      emit(state.copyWith(saleStatus: SaleStatus.initial));
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }
}
