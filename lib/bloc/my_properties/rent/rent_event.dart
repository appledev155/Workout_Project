part of 'rent_bloc.dart';

@immutable
abstract class RentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RentFetched extends RentEvent {}

class RentResetStateState extends RentEvent {}
