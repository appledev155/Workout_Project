
import 'package:isar/isar.dart';
part 'groupactivity.g.dart';
@Name('groupactivity')
@Collection()
class GroupActivity{
  @Index(unique:true)
  Id? id;
  String group_activity_selectevalue;
  GroupActivity({this.id,required this.group_activity_selectevalue});
}