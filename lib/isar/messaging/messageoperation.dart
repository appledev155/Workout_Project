import 'package:anytimeworkout/isar/messaging/message.dart';
import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';

class MessageOperation extends IsarServices{
  insert(Message message)async{
final isar=await db;
await isar.writeTxn(()async {
await isar.messages.put(message);
});
  }
  Future<List<Message>>getmessagevalue()async{
    final isar=await db;
    final result=await isar.messages.filter().messageselectvalueIsNotEmpty().findAll();
    // print(result);
    return result;
  }
}