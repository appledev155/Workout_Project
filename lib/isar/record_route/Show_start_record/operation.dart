import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:anytimeworkout/isar/record_route/Show_start_record/startendcoordinate.dart';

class StartEndOperation extends IsarServices {
  insert(StartEndCoordinate startEndCoordinate) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.startEndCoordinates.put(startEndCoordinate);
      print("************************>>>>>>>>$startEndCoordinate");
    });
  }

  Future<List<StartEndCoordinate>> getdata() async {
    final isar = await db;
    final result = await isar.startEndCoordinates.filter().dateIsNotEmpty().findAll();
     print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<$result");
    return result;
  }

  Future<void> saveData(StartEndCoordinate startEndCoordinate) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.startEndCoordinates.put(startEndCoordinate);
      print(">>>>>>>>>>>>>>>>>>>>>>$startEndCoordinate");
    });
  }

  Future<void> deleteRecord(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.startEndCoordinates.filter().dateIsEmpty().deleteAll();
    });
  }
}
