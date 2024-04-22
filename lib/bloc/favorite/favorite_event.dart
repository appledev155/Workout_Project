part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<ItemModel> get props => [];
}

class FavoriteFetched extends FavoriteEvent {}

class FavoriteRefresh extends FavoriteEvent {}

class ResetFavoriteState extends FavoriteEvent {}
