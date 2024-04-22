import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'display.dart';

class DisplayOperation extends IsarServices {
  insert(Display display) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.displays.put(display);
    });
  }

  Future<List<Display>> getselectvalue() async {
    final isar = await db;
    final result =
        await isar.displays.filter().selectedmeasurevalueIsNotEmpty().findAll();
    return result;
  }

  Future<List<Display>> gettemp() async {
    final isar = await db;
    final tempvalue =
        await isar.displays.filter().selectedtempvalueIsNotEmpty().findAll();
    return tempvalue;
  }

  Future<List<Display>> getdefault() async {
    final isar = await db;
    final defaultvalue =
        await isar.displays.filter().selecteddefaultvalueIsNotEmpty().findAll();
    return defaultvalue;
  }
}
