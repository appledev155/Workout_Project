import 'package:isar/isar.dart';
part 'display.g.dart';
@Name('display')
@Collection()
class Display{
  @Index(unique:true)
  Id? id;
  String? selectedmeasurevalue;
  String? selectedtempvalue;
  String? selecteddefaultvalue;
  Display({this.id,required this.selectedmeasurevalue,required this.selectedtempvalue,required this.selecteddefaultvalue });
}