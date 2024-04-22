part of 'search_result_bloc.dart';

class SearchResultEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchResultFetched extends SearchResultEvent {
  SearchResultFetched();
}

class SearchAgentResultFetched extends SearchResultEvent {
  SearchAgentResultFetched();
}

class SortByValueChanged extends SearchResultEvent {
  final String? sortValue;
  SortByValueChanged({this.sortValue});
}

class SetStateSearchResultFetched extends SearchResultEvent {
  SetStateSearchResultFetched();
}

class SetDefaultSearch extends SearchResultEvent {
  SetDefaultSearch();
}
