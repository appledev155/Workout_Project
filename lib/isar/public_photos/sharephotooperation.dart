import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:anytimeworkout/isar/public_photos/sharePhoto.dart';
import 'package:isar/isar.dart';


class SharePhotoOperation extends IsarServices{
  inser(SharePhoto sharephoto)async{
  final isar=await db;
  await isar.writeTxn(()async{
    await isar.sharePhotos.put(sharephoto);
  });
  }
  Future<List<SharePhoto>>getvalue()async{
    final isar=await db;
    final result=await isar.sharePhotos.filter().selectvalueEqualTo(true).findAll();
    return result;
  }
}