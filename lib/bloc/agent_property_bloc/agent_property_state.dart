part of 'agent_property_bloc.dart';

enum AgentPropertyStatus { initial, success, failure }

class AgentPropertyState extends Equatable {
  final AgentPropertyStatus status;
  final List<ItemModel> items;
  final bool? hasReachedMax, loadshow;
  final int? page;
  final String? searchCounts;
  final Object? searchCond;

  const AgentPropertyState({
    this.status = AgentPropertyStatus.initial,
    this.items = const <ItemModel>[],
    this.page = 1,
    this.searchCond,
    this.searchCounts = '',
    this.hasReachedMax = false,
    this.loadshow = false,
  });
  @override
  List<Object?> get props => [
        items,
        searchCounts,
        searchCounts,
        page,
        hasReachedMax,
        status,
        loadshow
      ];

  AgentPropertyState copyWith(
      {List<ItemModel>? items,
      AgentPropertyStatus? status,
      int? page,
      String? searchCounts,
      Object? searchCond,
      bool? hasReachedMax,
      bool? loadshow}) {
    return AgentPropertyState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      searchCond: searchCond ?? this.searchCond,
      searchCounts: searchCounts ?? this.searchCounts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loadshow: loadshow ?? this.loadshow,
    );
  }
}
