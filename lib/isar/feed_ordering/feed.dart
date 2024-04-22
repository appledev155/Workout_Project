import 'package:isar/isar.dart';
part 'feed.g.dart';
@Collection()
@Name("feed")
class Feed{
  @Index(unique:true)
  Id? id;
  String feedselectvalue;
  Feed({this.id,required this.feedselectvalue});
}