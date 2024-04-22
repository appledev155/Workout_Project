import 'package:isar/isar.dart';
part 'dataPermissionOptions.g.dart';
@Name('dataPermission')
@Collection()
class DataPermissionOptions{
  @Index(unique:true)
  Id? id;
  String? dataselectedvalue;
  DataPermissionOptions({this.id,this.dataselectedvalue});

}