import 'package:isar/isar.dart';
part 'sharePhoto.g.dart';
@Name("sharephoto")
@Collection()
class SharePhoto{
  @Index(unique:true)
  Id? id;
  bool selectvalue;
  SharePhoto({this.id,required this.selectvalue});
}