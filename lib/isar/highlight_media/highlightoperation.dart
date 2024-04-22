import 'package:anytimeworkout/isar/highlight_media/highlight.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';



class HighlightOperation extends IsarServices{
  insert(Highlight highlight)async{
  final isar=await db;
  await isar.writeTxn(()async{
    await isar.highlights.put(highlight);
  });
  }
  Future<List<Highlight>>gethighlightdata()async{
    final isar=await db;
    final result=await isar.highlights.filter().highlightselectvalueIsNotEmpty().findAll();
    return result;
  }
}