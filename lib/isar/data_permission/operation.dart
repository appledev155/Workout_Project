import 'package:anytimeworkout/isar/data_permission/dataPermissionOptions.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';


class DataOperation extends IsarServices{
  insert(DataPermissionOptions dataPermissionOptions)async{
    final isar=await db;
    await isar.writeTxn(()async {
      await isar.dataPermissionOptions.put(dataPermissionOptions);
    });
  }
  Future<List<DataPermissionOptions>> getdatavalue()async{
   final isar=await db;
   final result=await isar.dataPermissionOptions.filter().dataselectedvalueIsNotEmpty().findAll();
   return result;
  }
}