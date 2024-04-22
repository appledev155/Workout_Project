import 'package:isar/isar.dart';
part 'updation.g.dart';
@Name('updation')
@Collection()
class Updation{
  @Index(unique:true)
  Id? id;
  String updationselectedvalue;
  Updation({this.id,required this.updationselectedvalue});

}