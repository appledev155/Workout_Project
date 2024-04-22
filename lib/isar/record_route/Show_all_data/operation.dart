import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/record_route/Show_all_data/recordcoordinate.dart';
import 'package:anytimeworkout/isar/isar_services.dart';

class RecordCoordinateOperation extends IsarServices {
  insert(RecordCoordinate recordCoordinate)async{
    final isar=await db;
    await isar.writeTxn(()async{
        await isar.recordCoordinates.put(recordCoordinate);
    });
  }
  Future<List<RecordCoordinate>>getdata()async{
    final isar=await db;
    final result=isar.recordCoordinates.where().findAll();
    return result;
  }
  // Future<List<RecordCoordinate>> getlatitude() async {
  //   final isar = await db;
  //   final result =
  //       await isar.recordCoordinates.filter().latitudeIsNotEmpty().findAll();
  //   return result;
  // }
  //  Future<List<RecordCoordinate>> getlongitude() async {
  //   final isar = await db;
  //   final result =
  //       await isar.recordCoordinates.filter().longitudeIsNotEmpty().findAll();
  //   return result;
  // }
}
