part of 'favorite_bloc.dart';

enum FavoriteStatus { initial, failure, sucess, updating }

class FavoriteState extends Equatable {
  final List<ItemModel>? items;
  final bool? hasReachedMax;
  final int? page;
  final FavoriteStatus status;

  const FavoriteState(
      {this.items = const <ItemModel>[],
      this.page = 1,
      this.hasReachedMax = false,
      this.status = FavoriteStatus.initial});

  @override
  List<Object?> get props => [items, page, hasReachedMax, status];
  FavoriteState copyWith({
    List<ItemModel>? items,
    int? page,
    bool? hasReachedMax,
    FavoriteStatus? status,
  }) {
    return FavoriteState(
        items: items ?? this.items,
        page: page ?? this.page,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        status: status ?? this.status);
  }
}
