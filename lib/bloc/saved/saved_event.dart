part of 'saved_bloc.dart';

@immutable
abstract class SavedEvent extends Equatable {
  @override
  List<dynamic> get props => [];
}

class SavedFetched extends SavedEvent {}

class SavedRefresh extends SavedEvent {}
