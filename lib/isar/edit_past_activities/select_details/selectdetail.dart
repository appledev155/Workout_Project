import 'package:isar/isar.dart';
part 'selectdetail.g.dart';
@Name('selectdetail')
@Collection()
class SelectDetail{
  @Index(unique:true)
  Id? id;
  String selectdetailsvalue;
  SelectDetail({this.id,required this.selectdetailsvalue});
}