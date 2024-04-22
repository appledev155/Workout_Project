import 'package:isar/isar.dart';
part 'activities.g.dart';
@Collection()
@Name("activity")
class Activity{
@Index(unique:true)
Id? id;
String Activityselectvalue;
Activity({this.id,required this.Activityselectvalue});
}
