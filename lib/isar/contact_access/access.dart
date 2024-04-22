import 'package:isar/isar.dart';
part 'access.g.dart';
@Name('access')
@Collection()
class Access{
  @Index(unique:true)
  Id? id;
  bool accessvalue;
  Access({this.id,required this.accessvalue});
}