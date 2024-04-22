import 'package:isar/isar.dart';
part 'highlight.g.dart';
@Collection()
@Name("highlight")
class Highlight{
  @Index(unique:true)
  Id? id;
  String Highlightselectvalue;
  Highlight({this.id,required this.Highlightselectvalue});
}