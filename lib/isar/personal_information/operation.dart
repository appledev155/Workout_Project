import 'package:anytimeworkout/isar/personal_information/personalinformation.dart';
import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';


class Operation extends IsarServices{
  insert(PersonalInformation personalInformation)async{
    final isar=await db;
   await isar.writeTxn(() async{
   await isar.personalInformations.put(personalInformation);
   });
  }
  Future<List<PersonalInformation>>getdata()async{
    final isar=await db;
    final result=await isar.personalInformations.filter().selectedvalueEqualTo(true).findAll();
    return result;
  }
}