part of 'sale_bloc.dart';

@immutable
abstract class SaleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SaleFetched extends SaleEvent {}

class SaleResetStateState extends SaleEvent {}
