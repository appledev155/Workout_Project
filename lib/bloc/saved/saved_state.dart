part of 'saved_bloc.dart';

enum SaveStatus { initial, failure, success }

class SavedState extends Equatable {
  final SaveStatus? saveStatus;
  final List<dynamic>? items;
  final List<dynamic>? recIdsList;
  final bool? hasReachedMax;
  final int? page;
  const SavedState(
      {this.saveStatus = SaveStatus.initial,
      this.items = const <dynamic>[],
      this.hasReachedMax = false,
      this.recIdsList = const <dynamic>[],
      this.page = 1});
  @override
  List<Object?> get props =>
      [saveStatus!, items!, recIdsList, hasReachedMax, page];

  SavedState copyWith(
      {SaveStatus? saveStatus,
      List<dynamic>? items,
      List<dynamic>? recIdsList,
      bool? hasReachedMax,
      int? page}) {
    return SavedState(
        saveStatus: saveStatus ?? this.saveStatus,
        items: items ?? this.items,
        recIdsList: recIdsList ?? this.recIdsList,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}
/* @immutable
abstract class SavedState extends Equatable {
  const SavedState();

  @override
  List<Object> get props => [];
}

class SavedInitial extends SavedState {}

class SavedFailure extends SavedState {}

class SavedSuccess extends SavedState {
  final List<dynamic>? items;
  final List<dynamic>? recIdsList;
  final bool? hasReachedMax;
  final int? page;

  const SavedSuccess(
      {this.items, this.recIdsList, this.page, this.hasReachedMax});

  SavedSuccess copyWith(
      {List<dynamic>? items,
      List<dynamic>? recIdsList,
      int? page,
      bool? hasReachedMax}) {
    return SavedSuccess(
      items: items ?? this.items,
      recIdsList: recIdsList ?? this.recIdsList,
      page: page != null ? 1 : this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [items!, recIdsList!, page!, hasReachedMax!];

  @override
  String toString() =>
      'Item Sucess { items: ${items!.length}, recIdsList: ${recIdsList!.length}, page: $page,  hasReachedMax: $hasReachedMax}';
} */
