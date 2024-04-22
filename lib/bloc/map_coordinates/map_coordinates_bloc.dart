import 'dart:async';

import 'package:anytimeworkout/isar/record_route/Show_all_data/operation.dart' as records_latlang;
import 'package:anytimeworkout/isar/record_route/Show_start_record/operation.dart'
    as start_end_operation;
import 'package:anytimeworkout/model/map_coordinates_model.dart';
import 'package:darq/darq.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

part 'map_coordinates_event.dart';
part 'map_coordinates_state.dart';

class MapCoordinatesBloc
    extends Bloc<MapCoordinatesEvent, MapCoordinatesState> {
  MapCoordinatesBloc() : super(const MapCoordinatesState()) {
    on<FetchMapData>(_onFetchMapData);
  }
  // start_end_operation.StartEndOperation startEndOperation =
  //     start_end_operation.StartEndOperation();

records_latlang.RecordCoordinateOperation records = records_latlang.RecordCoordinateOperation();

  FutureOr<void> _onFetchMapData(
      FetchMapData event, Emitter<MapCoordinatesState> emit) async {
    
    //  emit(state.copyWith(mapStatus: MapCoordinatesStatus.initial));
    final result = await records.getdata();
    List<MapCoordinateModel> mapArray = [];
    for (var element in result) {
      mapArray.add(MapCoordinateModel(
        id: element.id,
          date: element.date,
          distance: element.distance,
          duration: element.duration,
          latitude: element.latitude,
          longitude: element.longitude));
    }
    print({"${mapArray}"});
    emit(state.copyWith(
        mapStatus: MapCoordinatesStatus.success,
        mapModelList: mapArray.reverse().toList()));
  }
}
