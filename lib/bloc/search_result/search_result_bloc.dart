import 'dart:async';
import 'dart:convert';
import 'package:anytimeworkout/config/constant.dart';

import '../../model/item_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

part 'search_result_event.dart';
part 'search_result_state.dart';

const throttleDuration = Duration(seconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  SearchResultBloc() : super(const SearchResultState()) {
    on<SearchResultFetched>(_onSearchResultFetched,
        transformer: throttleDroppable(throttleDuration));
    on<SearchAgentResultFetched>(_onSearchAgentFetch);
    on<SortByValueChanged>(_onSortChanged);
    on<SetStateSearchResultFetched>(_onSetState);
    on<SetDefaultSearch>(_onSetDefaultSearch);
  }

  _onSetDefaultSearch(SetDefaultSearch event, Emitter<SearchResultState> emit) {
    emit(state.copyWith(
      defaultSearch: false,
    ));
  }

  Future<void> _onSearchResultFetched(
      SearchResultFetched event, Emitter<SearchResultState> emit) async {
    try {
      Map<String, Object> jsonData = {};
      Map<String, Object> searchCond = {};

      String? algoliaCacheKey =
          await app_instance.storage.read(key: 'algolia_cache_key') ?? '';
      if (state.hasReachedMax!) return;
      if (state.status == SearchResultStatus.failure) {
        return emit(state.copyWith(status: SearchResultStatus.initial));
      }
      if (state.status == SearchResultStatus.initial) {
        dynamic rec = await app_instance.storage.read(key: 'jsonLastSearch');

        String? sortValue =
            await app_instance.storage.read(key: 'sortBy') ?? 'newest';
        if (rec != null) {
          dynamic data = jsonDecode(rec);
          searchCond = {
            'property_type_id': "${data['property_type_id']}",
            'buyrent_type': "${data['buyrent_type']}",
            'property_type': "${data['property_type']}".toLowerCase(),
            'property_type_option':
                '${data['property_type_option']}'.toString(),
            'year_built': "${data['year_built']}",
            'bedrooms': "${data['bedrooms']}",
            'toilet': "${data['toilet']}",
            'minprice': "${data['minprice']}",
            'maxprice': "${data['maxprice']}",
            'minarea': "${data['minarea']}",
            'maxarea': "${data['maxarea']}",
            'price_type': "${data['price_type']}",
            'property_area_unit': "${data['property_area_unit']}",
            'location_id_area': "${data['location_id_area']}",
            'location': "${data['location']}",
            'locationEnglish': "${data['locationEnglish']}",
            'amenities': "${data['amenities']}",
            'sort_by': sortValue.toString()
          };
          jsonData = {
            'page': '1',
            'app_version': '1',
            'cache_key': algoliaCacheKey,
            'search_cond': json.encode(searchCond)
          };
        } else {
          searchCond = {
            'property_type_id': '',
            'buyrent_type': '',
            'property_type': '',
            'property_type_option': '',
            'year_built': '',
            'bedrooms': '',
            'toilet': '',
            'minprice': '',
            'maxprice': '',
            'minarea': '',
            'maxarea': '',
            'price_type': '0',
            'property_area_unit': '',
            'location_id_area': '',
            'location': '',
            'locationEnglish': '',
            'amenities': '',
            'sort_by': 'newest',
            'cityArrayIndex': '0'
          };
          jsonData = {
            'page': '1',
            'app_version': '1',
            'cache_key': algoliaCacheKey,
            'search_cond': json.encode(searchCond)
          };
        }

        dynamic items = await app_instance.itemApiProvider.fetchItem(jsonData);

        if ((items.runtimeType == Null) ||
            (items.length > 0 &&
                items[0].runtimeType != ItemModel &&
                items[0].containsKey('error'))) {
          return emit(state.copyWith(
            status: SearchResultStatus.failure,
            items: [],
            page: 1,
            searchCounts: "0",
            searchCond: searchCond,
            hasReachedMax: false,
          ));
        }

        bool loadshow = false;
        if (items.length <
            ((app_instance.appConfig.numberOfRecords == 500) ? 450 : 90)) {
          loadshow = true;
        }
        String? searchCounts =
            await app_instance.storage.read(key: 'searchCounts');
        return emit(state.copyWith(
          status: SearchResultStatus.success,
          items: items,
          page: 1,
          searchCounts: searchCounts,
          searchCond: searchCond,
          hasReachedMax: loadshow,
        ));
      }

      int page = state.page! + 1;

      Map<String, Object> jsonData1 = {
        'page': page.toString(),
        'app_version': '1',
        'cache_key': algoliaCacheKey,
        'search_cond': json.encode(state.searchCond)
      };

      final items = await app_instance.itemApiProvider.fetchItem(jsonData1);

      if ((items.runtimeType == Null) ||
          (items.length > 0 &&
              items[0].runtimeType != ItemModel &&
              items[0].containsKey('error'))) {
        return emit(state.copyWith(
          status: SearchResultStatus.failure,
          items: [],
          page: 1,
          searchCounts: "0",
          searchCond: searchCond,
          hasReachedMax: false,
        ));
      }

      String? searchCounts =
          await app_instance.storage.read(key: 'searchCounts');
      Constants.counter.value = searchCounts.toString();
      bool loadshow = false;
      if (items.length <
          ((app_instance.appConfig.numberOfRecords == 500) ? 450 : 90)) {
        loadshow = true;
      }

      items.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: SearchResultStatus.success,
                items: List.of(state.items!)..addAll(items),
                page: page,
                hasReachedMax: loadshow,
                searchCounts: searchCounts,
                searchCond: state.searchCond,
              ),
            );
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }

  Future<void> _onSortChanged(
      SortByValueChanged event, Emitter<SearchResultState> emit) async {
    try {
      emit(state.copyWith(status: SearchResultStatus.initial));
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }

  Future<void> _onSearchAgentFetch(
      SearchAgentResultFetched event, Emitter<SearchResultState> emit) async {
    try {
      String? algoliaCacheKey =
          await app_instance.storage.read(key: 'algolia_cache_key') ?? '';
      if (state.hasReachedMaxAgent!) return;
      if (state.agentStatus == SearchResultStatus.failure) {
        emit(state.copyWith(agentStatus: SearchResultStatus.initial));
      }
      if (state.agentStatus == SearchResultStatus.initial) {
        dynamic rec = await app_instance.storage.read(key: 'jsonLastSearch');
        Map<String, Object> jsonData = {};
        Map<String, Object> searchCond = {};
        if (rec != null) {
          dynamic data = jsonDecode(rec);
          String? sortValue =
              await app_instance.storage.read(key: 'sortBy') ?? 'newest';

          searchCond = {
            'property_type_id': "${data['property_type_id']}",
            'buyrent_type': "${data['buyrent_type']}",
            'property_type': "${data['property_type']}".toLowerCase(),
            'property_type_option': (data['property_type_option'] != null)
                ? "${data['property_type_option']}"
                : '1',
            'year_built': "${data['year_built']}",
            'bedrooms': "${data['bedrooms']}",
            'toilet': "${data['toilet']}",
            'minprice': "${data['minprice']}",
            'maxprice': "${data['maxprice']}",
            'minarea': "${data['minarea']}",
            'maxarea': "${data['maxarea']}",
            'price_type': "${data['price_type']}",
            'property_area_unit': "${data['property_area_unit']}",
            'location_id_area': "${data['location_id_area']}",
            'location': "${data['location']}",
            'locationEnglish': "${data['locationEnglish']}",
            'amenities': "${data['amenities']}",
            'sort_by': sortValue.toString()
          };
          jsonData = {
            'page': '1',
            'app_version': '1',
            'cache_key': algoliaCacheKey,
            'search_cond': json.encode(searchCond)
          };
        } else {
          searchCond = {
            'property_type_id': '',
            'buyrent_type': 'Sell',
            'property_type': 'residential',
            'property_type_option': '1',
            'year_built': '',
            'bedrooms': '',
            'toilet': '',
            'minprice': '',
            'maxprice': '',
            'minarea': '',
            'maxarea': '',
            'price_type': '0',
            'property_area_unit': '',
            'location_id_area': '',
            'location': '',
            'locationEnglish': '',
            'amenities': '',
            'sort_by': 'newest',
            'cityArrayIndex': '0'
          };
          jsonData = {
            'page': '1',
            'app_version': '1',
            'cache_key': algoliaCacheKey,
            'search_cond': json.encode(searchCond)
          };
        }
        dynamic agentItems =
            await app_instance.itemApiProvider.fetchItemAgent(jsonData);

        bool loadshow = false;
        if (agentItems.length <
            ((app_instance.appConfig.numberOfRecords == 500) ? 450 : 90)) {
          loadshow = true;
        }

        String? searchCounts =
            await app_instance.storage.read(key: 'searchCounts1');
        Constants.countAgent.value =
            (searchCounts != null) ? int.parse(searchCounts.toString()) : 0;
        return emit(state.copyWith(
          agentStatus: SearchResultStatus.success,
          agentitems: agentItems,
          agentpage: 1,
          searchAgentCount: searchCounts,
          searchCond: searchCond,
          hasReachedMaxAgent: loadshow,
        ));
      }

      int agentpage = state.agentpage! + 1;

      Map<String, Object> jsonData = {
        'page': agentpage.toString(),
        'app_version': '1',
        'cache_key': algoliaCacheKey,
        'search_cond': json.encode(state.searchCond)
      };

      final agentItems =
          await app_instance.itemApiProvider.fetchItemAgent(jsonData);
      String? searchCounts =
          await app_instance.storage.read(key: 'searchCounts1');
      Constants.countAgent.value = int.parse(searchCounts.toString());
      bool loadshow = false;
      if (agentItems.length <
          ((app_instance.appConfig.numberOfRecords == 500) ? 450 : 90)) {
        loadshow = true;
      }
      agentItems.isEmpty
          ? emit(state.copyWith(hasReachedMaxAgent: true))
          : emit(
              state.copyWith(
                agentStatus: SearchResultStatus.success,
                agentitems: [...state.agentitems!, ...agentItems],
                agentpage: agentpage,
                hasReachedMaxAgent: loadshow,
                searchAgentCount: searchCounts,
                searchCond: state.searchCond,
              ),
            );
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }

  Future<void> _onSetState(SetStateSearchResultFetched event,
      Emitter<SearchResultState> emit) async {
    emit(state.copyWith(
      status: SearchResultStatus.initial,
    ));
  }
}

/* class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  SearchResultBloc() : super(SearchResultInitial());

  @override
  Stream<SearchResultState> mapEventToState(
    SearchResultEvent event,
  ) async* {
    final currentState = state;

    if (event is SearchResultFetched && !_hasReachedMax(currentState)) {
      String? algoliaCacheKey = await _storage.read(key: 'algolia_cache_key');
      try {
        if (currentState is SearchResultInitial) {
          dynamic rec = json
              .decode(await _storage.read(key: 'jsonLastSearch').toString());

          Object searchCond = {
            'property_type_id': rec['property_type_id'].toString(),
            'buyrent_type': rec['buyrent_type'].toString(),
            'property_type': rec['property_type'].toString(),
            'property_type_option': rec['property_type_option'].toString(),
            'year_built': rec['year_built'].toString(),
            'bedrooms': rec['bedrooms'].toString(),
            'toilet': rec['toilet'].toString(),
            'minprice': rec['minprice'].toString(),
            'maxprice': rec['maxprice'].toString(),
            'minarea': rec['minarea'].toString(),
            'maxarea': rec['maxarea'].toString(),
            'price_type': rec['price_type'].toString(),
            'property_area_unit': rec['property_area_unit'].toString(),
            'location_id_area': rec['location_id_area'].toString(),
            'location': rec['location'].toString(),
            'amenities': rec['amenities'],
            'sort_by': rec['sort_by']
          };
          Object jsonData = {
            'page': '1',
            'app_version': '1',
            'cache_key': algoliaCacheKey,
            'search_cond': json.encode(searchCond)
          };
          final items = await _itemApiProvider.fetchItem(jsonData);
          bool loadshow = false;
          if (items.length < 15) loadshow = true;

          String? searchCounts = await _storage.read(key: 'searchCounts');
          //String redis = await _storage.read(key: 'redis_key');

          yield SearchResultSuccess(
              items: items,
              page: 1,
              searchCounts: searchCounts!,
              searchCond: searchCond,
              //  redis: redis,
              hasReachedMax: loadshow);
          return;
        }

        if (currentState is SearchResultSuccess) {
          final nextPage = currentState.page! + 1;

          Object jsonData = {
            'page': nextPage.toString(),
            'app_version': '1',
            'cache_key': algoliaCacheKey,
            'search_cond': json.encode(currentState.searchCond)
          };

          final items = await _itemApiProvider.fetchItem(jsonData);

          bool loadshow = false;
          if (items.length < 15) loadshow = true;

          String? searchCounts = await _storage.read(key: 'searchCounts');
          // String redis = await _storage.read(key: 'redis_key');

          yield items.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : SearchResultSuccess(
                  items: currentState.items! + items,
                  page: nextPage,
                  searchCounts: searchCounts!,
                  searchCond: currentState.searchCond,
                  // redis: redis,
                  hasReachedMax: loadshow,
                );
        }
      } catch (_) {
        print(_);
        yield SearchResultFailure();
      }
    }
    if (event is ResetStateState) {
      yield SearchResultInitial();
      return;
    }
  }

  bool _hasReachedMax(SearchResultState state) =>
      state is SearchResultSuccess && state.hasReachedMax!;
}
 */
