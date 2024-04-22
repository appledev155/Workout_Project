import 'package:anytimeworkout/isar/group_activities/groupactivity.dart';
import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';


class GroupActivityOperation extends IsarServices{
  insert(GroupActivity groupActivity)async{
  final isar=await db;
  await isar.writeTxn(() async{
    await isar.groupActivitys.put(groupActivity);
  });
}
Future<List<GroupActivity>> getgroupactivity() async {
    final isar = await db;
    final result = await isar.groupActivitys.filter().group_activity_selectevalueIsNotEmpty().findAll();
    return result;
  }
}