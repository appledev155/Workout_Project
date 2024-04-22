part of 'map_coordinates_bloc.dart';

enum MapCoordinatesStatus {
  initial,
  success,
  loading,
  loaded,
  error,
  start,
  deletelist
}

class MapCoordinatesState extends Equatable {
  final MapCoordinatesStatus? mapStatus;
  final List<MapCoordinateModel>? mapModelList;

  const MapCoordinatesState(
      {this.mapStatus = MapCoordinatesStatus.initial,
      this.mapModelList = const []});

  @override
  List<Object> get props => [mapStatus!, mapModelList!];
  MapCoordinatesState copyWith({
    MapCoordinatesStatus? mapStatus,
    List<MapCoordinateModel>? mapModelList,
  }) {
    return MapCoordinatesState(
        mapStatus: mapStatus ?? this.mapStatus,
        mapModelList: mapModelList ?? this.mapModelList);
  }
}
