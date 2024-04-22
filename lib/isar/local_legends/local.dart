import 'package:isar/isar.dart';
part 'local.g.dart';
@Collection()
@Name("local")
class Local{
  @Index(unique: true)
  Id? id;
  String localselectvalue;
  Local({this.id,required this.localselectvalue});
}