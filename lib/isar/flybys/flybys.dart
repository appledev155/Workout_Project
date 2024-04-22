import 'package:isar/isar.dart';
part 'flybys.g.dart';
@Collection()
@Name('flybys')
class Flybys{
  @Index(unique:true)
  Id? id;
  String flybysselectvalue;
  Flybys({this.id,required this.flybysselectvalue});
}