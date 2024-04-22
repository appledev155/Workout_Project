import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../model/item_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

part 'agent_property_event.dart';
part 'agent_property_state.dart';

// final dynamic durationTime = dotenv.env['THROTTLEDURATION'];
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AgentPropertyBloc extends Bloc<AgentPropertyEvent, AgentPropertyState> {
  AgentPropertyBloc() : super(const AgentPropertyState()) {
    on<AgentPropertyFetched>(_onAgentPropertyFetched,
        transformer: throttleDroppable(throttleDuration));
    // on<ResetAgentProperty>(_onResetAgentProperty);
  }

  Future<void> _onAgentPropertyFetched(
      AgentPropertyFetched event, Emitter<AgentPropertyState> emit) async {
    String? algoliaCacheKey =
        await app_instance.storage.read(key: 'algolia_cache_key');
    String? getpropertyAreaUnit =
        await app_instance.storage.read(key: 'propertyAreaUnit');
    try {
      if (state.status == AgentPropertyStatus.initial) {
        //dynamic rec = json.decode(await app_instance.storage.read(key: 'jsonLastSearch'));

        Map<String, Object> searchCond = {
          'user_id': '${event.userId}',
          'property_type_id': '${event.propertyTypeId ?? 0}',
          'buyrent_type': event.buyRentType ?? '',
          'property_typename': event.propertyType ?? '',
          'price_type': '0',
          'property_area_unit': getpropertyAreaUnit ?? '',
          'sort_by': 'newest'
        };
        Map<String, Object> jsonData = {
          'page': '1',
          'app_version': '1',
          'cache_key': algoliaCacheKey.toString(),
          'search_cond': json.encode(searchCond)
        };
        final items =
            await app_instance.itemApiProvider.getAgentProperty(jsonData);
        bool loadshow = false;
        if (items.length < 15) loadshow = true;
        emit(state.copyWith(
            items: items,
            page: 1,
            searchCond: searchCond,
            hasReachedMax: loadshow,
            status: AgentPropertyStatus.success));

        return;
      }
      if (state.status == AgentPropertyStatus.success) {
        final nextPage = state.page! + 1;

        Map<String, Object> jsonData = {
          'page': nextPage.toString(),
          'app_version': '1',
          'cache_key': algoliaCacheKey.toString(),
          'search_cond': json.encode(state.searchCond)
        };

        final items =
            await app_instance.itemApiProvider.getAgentProperty(jsonData);

        bool loadshow = false;
        if (items.length < 15) loadshow = true;
        (items.isEmpty)
            ? state.copyWith(hasReachedMax: true)
            : emit(state.copyWith(
                items: state.items + items,
                page: nextPage,
                searchCond: state.searchCond,
                hasReachedMax: loadshow,
                status: AgentPropertyStatus.success));
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
      emit(state.copyWith(status: AgentPropertyStatus.failure));
    }
  }
}
