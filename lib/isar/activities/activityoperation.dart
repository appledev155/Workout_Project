import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

import 'activities.dart';

class ActivityOperation extends IsarServices{
  insert(Activity activity)async{
  final isar=await db;
  await isar.writeTxn(() async{
    await isar.activitys.put(activity);
  });
}
Future<List<Activity>> getactivity() async {
    final isar = await db;
    final result = await isar.activitys.filter().activityselectvalueIsNotEmpty().findAll();
    return result;
  }
}