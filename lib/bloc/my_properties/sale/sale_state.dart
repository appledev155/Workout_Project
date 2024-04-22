part of 'sale_bloc.dart';

enum SaleStatus { initial, success, failure }

class SaleState extends Equatable {
  final SaleStatus? saleStatus;
  final List<ItemModel>? itemsSale;
  final bool? hasReachedMaxSale;
  final int? pageSale;

  const SaleState(
      {this.saleStatus = SaleStatus.initial,
      this.itemsSale = const <ItemModel>[],
      this.hasReachedMaxSale = false,
      this.pageSale = 1});
  @override
  List<Object?> get props =>
      [saleStatus!, itemsSale!, hasReachedMaxSale!, pageSale!];

  SaleState copyWith(
      {SaleStatus? saleStatus,
      List<ItemModel>? itemsSale,
      bool? hasReachedMaxSale,
      int? pageSale}) {
    return SaleState(
        saleStatus: saleStatus ?? this.saleStatus,
        itemsSale: itemsSale ?? this.itemsSale,
        hasReachedMaxSale: hasReachedMaxSale ?? this.hasReachedMaxSale,
        pageSale: pageSale ?? this.pageSale);
  }

  @override
  String toString() =>
      'Item Sucess { itemsSale: ${itemsSale!.length}, pageSale: $pageSale,  hasReachedMaxSale: $hasReachedMaxSale}';
}
/* @immutable
abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

class SaleInitial extends SaleState {}

class SaleFailure extends SaleState {}

class SaleSuccess extends SaleState {
  final List<ItemModel>? itemsSale;
  final bool? hasReachedMaxSale;
  final int? pageSale;

  const SaleSuccess({this.itemsSale, this.pageSale, this.hasReachedMaxSale});

  SaleSuccess copyWith(
      {List<ItemModel>? itemsSale, int? pageSale, bool? hasReachedMaxSale}) {
    return SaleSuccess(
      itemsSale: itemsSale ?? this.itemsSale,
      pageSale: pageSale != null ? 1 : this.pageSale,
      hasReachedMaxSale: hasReachedMaxSale ?? this.hasReachedMaxSale,
    );
  }

  @override
  List<Object> get props => [itemsSale!, pageSale!, hasReachedMaxSale!];

  @override
  String toString() =>
      'Item Sucess { itemsSale: ${itemsSale!.length}, pageSale: $pageSale,  hasReachedMaxSale: $hasReachedMaxSale}';
} */
