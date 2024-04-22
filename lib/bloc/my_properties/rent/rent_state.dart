part of 'rent_bloc.dart';

enum RentStatus { initial, success, failure }

class RentState extends Equatable {
  final RentStatus? rentStatus;
  final List<ItemModel>? itemsRent;
  final bool? hasReachedMaxRent;
  final int? pageRent;
  const RentState(
      {this.rentStatus = RentStatus.initial,
      this.itemsRent = const <ItemModel>[],
      this.hasReachedMaxRent = false,
      this.pageRent = 1});
  @override
  List<Object?> get props =>
      [rentStatus, itemsRent, hasReachedMaxRent, pageRent];

  RentState copyWith(
      {RentStatus? rentStatus,
      List<ItemModel>? itemsRent,
      bool? hasReachedMaxRent,
      int? pageRent}) {
    return RentState(
        rentStatus: rentStatus ?? this.rentStatus,
        itemsRent: itemsRent ?? this.itemsRent,
        hasReachedMaxRent: hasReachedMaxRent ?? this.hasReachedMaxRent,
        pageRent: pageRent ?? this.pageRent);
  }
}
/* @immutable
class RentState extends Equatable {
  const RentState();

  @override
  List<Object> get props => [];
}

class RentInitial extends RentState {}

class RentFailure extends RentState {}

class RentSuccess extends RentState {
  final List<ItemModel>? itemsRent;
  final bool? hasReachedMaxRent;
  final int? pageRent;

  const RentSuccess({this.itemsRent, this.pageRent, this.hasReachedMaxRent});

  RentSuccess copyWith(
      {List<ItemModel>? itemsRent, int? pageRent, bool? hasReachedMaxRent}) {
    return RentSuccess(
      itemsRent: itemsRent ?? this.itemsRent,
      pageRent: pageRent != null ? 1 : this.pageRent,
      hasReachedMaxRent: hasReachedMaxRent ?? this.hasReachedMaxRent,
    );
  }

  @override
  List<Object> get props => [itemsRent!, pageRent!, hasReachedMaxRent!];

  @override
  String toString() =>
      'Item Sucess { itemsRent: ${itemsRent!.length}, pageRent: $pageRent,  hasReachedMaxRent: $hasReachedMaxRent}';
} */
