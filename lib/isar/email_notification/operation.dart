import 'package:anytimeworkout/isar/email_notification/updation.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

class updation extends IsarServices{
  insert(Updation updation)async{
    final isar=await db;
    await isar.writeTxn(()async{
      await isar.updations.put(updation);
    });
  }
  Future<List<Updation>> getupdationvalue()async{
    final isar=await db;
    final result=await isar.updations.filter().updationselectedvalueIsNotEmpty().findAll();
    return result;
  }
}