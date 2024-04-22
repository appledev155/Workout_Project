import 'package:anytimeworkout/isar/edit_past_activities/select_details/selectdetail.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

class SelectDetailOperation extends IsarServices{
  insert(SelectDetail selectDetail)async{
    final isar=await db;
    await isar.writeTxn(()async{
      await isar.selectDetails.put(selectDetail);
    });
  }
  Future<List<SelectDetail>>getvalue()async{
    final isar=await db;
    final result=await isar.selectDetails.filter().selectdetailsvalueIsNotEmpty().findAll();
    return result;
  }
}