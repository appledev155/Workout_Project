import 'package:isar/isar.dart';
part 'message.g.dart';
@Collection()
@Name("message")
class Message{
  @Index(unique:true)
  Id? id;
  String messageselectvalue;
  Message({this.id,required this.messageselectvalue});
}