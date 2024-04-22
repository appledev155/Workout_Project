import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:anytimeworkout/isar/user/user_isar.dart';
import 'package:isar/isar.dart';

class User extends IsarServices {
  Future<void> saveUser(UserIsar user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.userIsars.put(user);
    });
  }

  Future<UserIsar?> getUserbyId(int id) async {
    final isar = await db;
    return await isar.userIsars.get(id);
  }

  Future<int> fetchLastUpdatedUser() async {
    final isar = await db;
    final result = await isar.userIsars
        .filter()
        .idGreaterThan(0)
        .sortByPublicUpdatedTimeTokenDesc()
        .findFirst();
    if (result != null) {
      return result.publicUpdatedTimeToken;
    } else {
      return 0;
    }
  }
}
