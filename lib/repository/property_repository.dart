import 'dart:async';
import 'package:flutter/foundation.dart';

import 'repository.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class PropertyRepository extends Repository {
  Future<dynamic> addProperty(jsonData) async {
    final resultData =
        await requestPOST(path: 'add_property_v2', parameters: jsonData);

    return resultData;
    /*  return resultData; */
  }

  Future<dynamic> addPropertyLocDesc(jsonData) async {
    final resultData =
        await requestPOST(path: 'add_property_loc_desc', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> addPropLocSet(jsonData) async {
    final resultData =
        await requestPOST(path: 'add_prop_loc_set', parameters: jsonData);
    return resultData;
  }

//    add_property_images
//    add_floore_plan_images

  Future<dynamic> appEditProperties(jsonData) async {
    final resultData =
        await requestGET(path: 'app_edit_properties', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> appDeletePropertyImages(jsonData) async {
    final resultData =
        await requestGET(path: 'delete_property_images', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> directDeploy(jsonData) async {
    final resultData =
        await requestGET(path: 'directDeploy', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> addPropertyImages(jsonData) async {
    final resultData =
        await requestPOST(path: 'add_property_images', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> getLocationList(jsonData, isAlgolia, loc, locationId) async {
    try {
      /* final resultData = await requestLocationGET(
        path: 'app_get_location_list', parameters: jsonData);
    return resultData; */

      dynamic testUser = await app_instance.storage.read(key: 'testUser');
      dynamic searchType = await app_instance.storage.read(key: 'searchType');

      var dbtype = '';
      if (testUser == 'true') {
        switch (searchType) {
          case '1': //laravel sql
            {
              dbtype = '_sql';
              isAlgolia = false;
              break;
            }
          case '2': //laravel alg0lia
            {
              dbtype = '_algolia';
              isAlgolia = false;
              break;
            }
          case '3': //Alglolia Rest API
            {
              isAlgolia = true;
              break;
            }
          default:
            break;
        }
      }

      final resultData = (isAlgolia)
          ? await locationPost(loc, locationId,
              path: 'app_get_location_list', parameters: jsonData)
          : await requestLocationGET(
              path: 'app_get_location_list$dbtype', parameters: jsonData);
      return resultData;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
    }
  }
}
