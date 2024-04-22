import 'package:anytimeworkout/isar/feed_ordering/feed.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';


class FeedOperation extends IsarServices{
  insert(Feed feed)async{
    final isar=await db;
    await isar.writeTxn(() async{
   await isar.feeds.put(feed);
    });
  }
  Future <List<Feed>> getfeeddata()async{
    final isar=await db;
    final result=isar.feeds.filter().feedselectvalueIsNotEmpty().findAll();
    return result;
  }
}