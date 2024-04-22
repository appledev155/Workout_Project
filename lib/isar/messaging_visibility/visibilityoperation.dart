import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:anytimeworkout/isar/messaging_visibility/visible.dart';
import 'package:isar/isar.dart';


class VisibilityOperation extends IsarServices{
  insert(Visible visible)async{
    final isar=await db;
    await isar.writeTxn(()async{
      await isar.visibles.put(visible);
    });
  }
  Future<List<Visible>>getviisibledata()async{
    final isar=await db;
    final result=await isar.visibles.filter().visibilityselectvalueEqualTo(true).findAll();
  //  print(result);
   return result;
  }
}