import 'package:anytimeworkout/isar/flybys/flybys.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';


class FlybysOperation extends IsarServices{
  insert(Flybys flybys)async{
  final isar=await db;
  await isar.writeTxn(() async{
    await isar.flybys.put(flybys);
  });
}
Future<List<Flybys>> getflybysvalue() async {
    final isar = await db;
    final result = await isar.flybys.filter().flybysselectvalueIsNotEmpty().findAll();
    return result;
  }
}