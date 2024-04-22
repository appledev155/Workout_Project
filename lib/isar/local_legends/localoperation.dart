import 'package:anytimeworkout/isar/local_legends/local.dart';
import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';


class LocalOperation extends IsarServices{
  insert(Local local)async{
  final isar=await db;
  await isar.writeTxn(() async{
    await isar.locals.put(local);
  });
}
Future<List<Local>> getlocaldata() async {
    final isar = await db;
    final result = await isar.locals.filter().localselectvalueIsNotEmpty().findAll();
    return result;
  }
}