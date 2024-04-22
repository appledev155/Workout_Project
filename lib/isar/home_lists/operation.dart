

import 'package:anytimeworkout/isar/home_lists/homelist.dart';
import 'package:isar/isar.dart';

import '../isar_services.dart';

class HomeListOperation extends IsarServices {
  Future<List<HomeList>> getDataList() async {
    final isar = await db;
    final result = await isar.homeLists.filter().distanceIsNotEmpty().findAll();
    return result;
  }

  Future<void> saveData(HomeList datalist) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.homeLists.put(datalist);
    });
  }

  Future<void> deleteData(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.homeLists.filter().idEqualTo(id).deleteAll();
    });
  }
}
