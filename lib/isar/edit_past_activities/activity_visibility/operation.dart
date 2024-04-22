import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'activityvisible.dart';

class ActivityVisibleOperation extends IsarServices{
insert(ActivityVisible activityVisible)async{
  final isar=await db;
  await isar.writeTxn(()async{
    await isar.activityVisibles.put(activityVisible);
  });
}
Future<List<ActivityVisible>> getvalue()async{
final isar=await db;
final result=await isar.activityVisibles.filter().activityselectedvalueIsNotEmpty().findAll();
return result;
}
}