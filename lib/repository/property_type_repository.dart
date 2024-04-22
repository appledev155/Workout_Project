import 'dart:async';
import 'dart:convert';
import 'repository.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class PropertyTypeRepository extends Repository {
  Future<dynamic> getPropertyType() async {
    dynamic data = await app_instance.storage.read(key: 'PropertyType');
    if (data.runtimeType == Null || data.toString() == '{}') {
      Map<String, Object> jsonData = {
        'db_type': 'member',
      };
      final resultData =
          await requestGET(path: 'app_get_property_type', parameters: jsonData);
      String data = jsonEncode(resultData);

      await app_instance.storage.write(key: "PropertyType", value: data);
      return data;
    } else {
      return data;
    }
  }
}
