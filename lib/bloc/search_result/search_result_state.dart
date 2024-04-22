part of 'search_result_bloc.dart';

enum SearchResultStatus { initial, loading, success, failure }

class SearchResultState extends Equatable {
  final SearchResultStatus? status;
  final SearchResultStatus? agentStatus;
  final List<dynamic>? items;
  final List<dynamic>? agentitems;

  final bool? hasReachedMax;
  final bool? hasReachedMaxAgent;
  final int? page;
  final int? agentpage;
  final String? searchCounts;
  final dynamic searchCond, searchAgentCount;
  final bool? defaultSearch;

  const SearchResultState(
      {this.status = SearchResultStatus.initial,
      this.agentStatus = SearchResultStatus.initial,
      this.items = const <dynamic>[],
      this.agentitems = const <dynamic>[],
      this.hasReachedMax = false,
      this.hasReachedMaxAgent = false,
      this.page = 1,
      this.agentpage = 1,
      this.searchCounts = "",
      this.searchCond = '',
      this.searchAgentCount = '',
      this.defaultSearch = true});

  SearchResultState copyWith(
      {SearchResultStatus? status,
      SearchResultStatus? agentStatus,
      List<dynamic>? items,
      bool? hasReachedMax,
      bool? hasReachedMaxAgent,
      int? page,
      int? agentpage,
      String? searchCounts,
      dynamic searchCond,
      dynamic searchAgentCount,
      List<dynamic>? agentitems,
      bool? defaultSearch}) {
    return SearchResultState(
      status: status ?? this.status,
      agentStatus: agentStatus ?? this.agentStatus,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      hasReachedMaxAgent: hasReachedMaxAgent ?? this.hasReachedMaxAgent,
      page: page ?? this.page,
      agentpage: agentpage ?? this.agentpage,
      searchCounts: searchCounts ?? this.searchCounts,
      searchCond: searchCond ?? this.searchCond,
      searchAgentCount: searchAgentCount ?? this.searchAgentCount,
      agentitems: agentitems ?? this.agentitems,
      defaultSearch: defaultSearch ?? this.defaultSearch,
    );
  }

  @override
  List<Object> get props => [
        status!,
        agentStatus!,
        items!,
        hasReachedMax!,
        hasReachedMaxAgent!,
        page!,
        agentpage!,
        searchCounts!,
        searchCond!,
        searchAgentCount,
        agentitems!,
        defaultSearch!
      ];

  @override
  String toString() =>
      'Item Sucess { agentStatus: $agentStatus, allStatus: $status, items: ${items!.length}, page: $page, agentPage: $agentpage, searchCounts : $searchCounts, hasReachedMax: $hasReachedMax, hasReachedMaxAgent: $hasReachedMaxAgent, defaultSearch: $defaultSearch}';
}

/*
@immutable
abstract class SearchResultState extends Equatable {
  const SearchResultState();

  @override
  List<Object> get props => [];
}

class SearchResultInitial extends SearchResultState {}

class SearchResultFailure extends SearchResultState {}

class SearchResultSuccess extends SearchResultState {
  final List<dynamic>? items;
  final bool? hasReachedMax;
  final int? page;
  final String? searchCounts;
  final Object? searchCond;
  // final String redis;

  const SearchResultSuccess(
      {this.items,
      this.page,
      this.searchCounts,
      this.searchCond,
      this.hasReachedMax});
  // this.redis

  SearchResultSuccess copyWith(
      {List<ItemModel>? items,
      int? page,
      String? searchCounts,
      Object? searchCond,
      bool? hasReachedMax}) {
    return SearchResultSuccess(
      items: items ?? this.items,
      page: page != null ? 1 : this.page,
      searchCounts: searchCounts == null ? '0' : this.searchCounts,
      // redis: redis == null ? '0' : this.redis,
      searchCond: searchCond == null ? {} : this.searchCond,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props =>
      [items!, page!, searchCounts!, searchCond!, hasReachedMax!];

  // redis,

  @override
  String toString() =>
      'Item Sucess { items: ${items!.length}, page: $page, searchCounts : $searchCounts, hasReachedMax: $hasReachedMax}';
}
 */
