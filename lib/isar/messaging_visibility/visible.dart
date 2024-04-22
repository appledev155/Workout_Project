import 'package:isar/isar.dart';
part 'visible.g.dart';
@Collection()
@Name("visible")
class Visible{
  @Index(unique:true)
  Id? id;
  late bool visibilityselectvalue;
  Visible({this.id,required this.visibilityselectvalue});
}