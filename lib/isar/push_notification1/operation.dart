import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

import 'notificationpush.dart';

class NotificationOperationPage extends IsarServices {
  insert(NotificationPush notificationPush) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.notificationPushs.put(notificationPush);
    });
  }

  Future<List<NotificationPush>> getactivitiesvalue() async {
    final isar = await db;
    final result =
        await isar.notificationPushs.filter().acitivitiesIsNotEmpty().findAll();
    return result;
  }

  Future<List<NotificationPush>> getfriendsvalue() async {
    final isar = await db;
    final result =
        await isar.notificationPushs.filter().friendsIsNotEmpty().findAll();
    return result;
  }
  Future<List<NotificationPush>> getchallengesvalue()async{
    final isar=await db;
    final result=await isar.notificationPushs.filter().challengesIsNotEmpty().findAll();
    return result;
  }
    Future<List<NotificationPush>> getclubsvalue()async{
    final isar=await db;
    final result=await isar.notificationPushs.filter().clubsIsNotEmpty().findAll();
    return result;
  }
     Future<List<NotificationPush>> geteventsvalue()async{
    final isar=await db;
    final result=await isar.notificationPushs.filter().eventsIsNotEmpty().findAll();
    return result;
  }
     Future<List<NotificationPush>> getpostsvalue()async{
    final isar=await db;
    final result=await isar.notificationPushs.filter().postsIsNotEmpty().findAll();
    return result;
  }
  Future<List<NotificationPush>> getdatavalue()async{
    final isar=await db;
    final result=await isar.notificationPushs.filter().dataselectedvalueIsNotEmpty().findAll();
    return result;
  }
  Future<List<NotificationPush>> getothervalue()async{
    final isar=await db;
    final result=await isar.notificationPushs.filter().otherIsNotEmpty().findAll();
    return result;
  }
}
