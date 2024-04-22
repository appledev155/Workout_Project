import 'package:isar/isar.dart';
part 'activityvisible.g.dart';
@Name('activityvisible')
@Collection()
class ActivityVisible{
  @Index(unique:true)
  Id? id;
  String Activityselectedvalue;
  ActivityVisible({this.id,required this.Activityselectedvalue});
}