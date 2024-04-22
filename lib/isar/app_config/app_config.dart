import 'dart:convert';

import 'package:anytimeworkout/isar/app_config/app_config_isar.dart';
import 'package:anytimeworkout/isar/isar_services.dart';
import 'package:isar/isar.dart';

class AppConfig extends IsarServices {
  Future<void> saveAppConfig(AppConfigIsar appConfig) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.appConfigIsars.put(appConfig);
    });
  }

  Stream<dynamic> watchAppConfig() async* {
    final isar = await db;
    yield* isar.appConfigIsars.watchLazy();
  }

  Future<int> countAppConfig() async {
    final isar = await db;
    final result = await isar.appConfigIsars.count();
    return result;
  }

  Future<List<AppConfigIsar>> fetchAllConfig() async {
    final isar = await db;
    final result = await isar.appConfigIsars.where().findAll();
    return result;
  }

  Future<dynamic> deleteConfig({required String configName}) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.appConfigIsars.deleteByConfigName(configName);
    });
  }

  Future<dynamic> fetchConfig({required String configName}) async {
    final isar = await db;
    final result = await isar.appConfigIsars
        .filter()
        .configNameEqualTo(configName)
        .limit(1)
        .findAll();

    if (result.isNotEmpty) {
      try {
        return jsonDecode(result.first.configValue);
      } catch (e) {
        return result.first.configValue;
      }
    } else {
      return null;
    }
  }
}
