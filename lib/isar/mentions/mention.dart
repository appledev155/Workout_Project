import 'package:isar/isar.dart';
part 'mention.g.dart';
@Name("mention")
@Collection()
class Mention{
  @Index(unique:true)
  Id? id;
  String mentionselectvalue;
  Mention({this.id,required this.mentionselectvalue});
}