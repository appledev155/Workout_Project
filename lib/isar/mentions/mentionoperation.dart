import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'mention.dart';

class MentionOperation extends IsarServices{
  insert(Mention mention)async{
    final isar= await db;
    await isar.writeTxn(()async{
  await isar.mentions.put(mention);
    });
  }
  Future<List<Mention>>getmentionsvalue()async{
final isar=await db;
final result=await isar.mentions.filter().mentionselectvalueIsNotEmpty().findAll();
return result;
  }
}