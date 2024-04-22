import 'package:anytimeworkout/isar/profile/profile.dart';
import 'package:isar/isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';

class ProfileOperation extends IsarServices{
insert(Profile profile)async{
  final isar=await db;
  await isar.writeTxn(() async{
    await isar.profiles.put(profile);
  });
}
Future<List<Profile>> getProfile() async {
    final isar = await db;
    final result = await isar.profiles.filter().selectedValueIsNotEmpty().findAll();
    return result;
  }
}