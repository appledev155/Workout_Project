import 'package:isar/isar.dart';

part 'app_config_isar.g.dart';

@collection
@Name("AppConfig")
class AppConfigIsar {
  Id? id;

  @Index(unique: true, replace: true)
  late String configName;

  late String configValue;

  @override
  String toString() => "{$configName, $configValue}";
}
