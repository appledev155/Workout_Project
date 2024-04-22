import 'package:anytimeworkout/isar/contact_access/access.dart';
import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';

class AccessOperation extends IsarServices{
  insert(Access access)async{
  final isar=await db;
  await isar.writeTxn(() async{
    await isar.access.put(access);
  });
  }
  Future<List<Access>> getaccessvalue()async{
    final isar=await db;
    final result=await isar.access.filter().accessvalueEqualTo(true).findAll();
    return result;
  }
}