// Given name  ItemModel
// Considering item will be any entiry like property, car, bike,
// in order to consider global scope I have given name item

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/config/constant.dart';
import 'package:anytimeworkout/model/agent_detail.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import '../model/item_model.dart';
import '../module/request/model/request_model.dart';
import 'repository.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class ItemApiProvider extends Repository {
  Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
  dynamic recList, rec;
  String? recString;

  // A function that converts a response body into a List<Property>.
  List<ItemModel> parseProperties(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ItemModel>((json) => ItemModel.fromJson(json)).toList();
  }

  Future<dynamic> fetchItem(jsonData) async {
    try {
      dynamic params = await app_instance.storage.read(key: 'get_algolia');

      dynamic tempData = await Notify().getArguments();
      if (tempData.runtimeType == Null) {
        await app_instance.utility.getAlgolia();
        tempData = await Notify().getArguments();
      }

      dynamic isAlgolia = false;
      String loc = '', indexName = '';
      var dbtype = '';

      if (params != null) {
        params = jsonDecode(params);
        if (params.toString() == '{}' ||
            (params.containsKey('MIX_ALGOLIA_REST_API_SEARCH') &&
                params['MIX_ALGOLIA_REST_API_SEARCH'].runtimeType != bool)) {
          await app_instance.utility.getAlgolia();
          params = await app_instance.storage.read(key: 'get_algolia');
          params = jsonDecode(params);
        }
        isAlgolia = (params.containsKey('MIX_ALGOLIA_REST_API_SEARCH'))
            ? params['MIX_ALGOLIA_REST_API_SEARCH'] ?? false
            : false;
        loc = params['MIX_ALGOLIA_REST_API'];
        indexName = 'dev_property';

        dynamic testUser = await app_instance.storage.read(key: 'testUser');
        dynamic searchType = await app_instance.storage.read(key: 'searchType');

        if (testUser == 'true') {
          if (searchType != null) {
            switch (searchType) {
              case '0': //laravel sql
                {
                  dbtype = '_sql';
                  isAlgolia = false;
                  break;
                }
              case '1': //laravel alg0lia
                {
                  dbtype = '_algolia';
                  isAlgolia = false;
                  break;
                }
              case '2': //Alglolia Rest API
                {
                  isAlgolia = true;
                  break;
                }
              default:
                break;
            }
          }
        }

        if (isAlgolia) {
          //REST API Algolia
          try {
            dynamic resultData =
                await searchAlgoliaPost(loc, indexName, parameters: jsonData)
                    .onError((error, stackTrace) => [
                          {'error': error.toString()}
                        ]);

            if (resultData.isNotEmpty) {
              dynamic searchCounts = resultData[0]['nbHits'];

              if (resultData[0].containsKey('error')) {
                return resultData;
              }

              dynamic deviceInfoJson = await getDeviceInfo();
              activityLogApi(jsonData, deviceInfoJson);

              if (searchCounts == null) {
                searchCounts = '0';
                await app_instance.storage
                    .write(key: "resetSearch", value: '1');
              }
              Constants.counter.value = searchCounts.toString();
              await app_instance.storage
                  .write(key: "searchCounts", value: searchCounts.toString());

              if (resultData[0]['hits'].length > 0) {
                return parseAlgoliaResult(
                    resultData[0]['hits'], tempData['STDCODE']);
              } else {
                return [];
              }
            } else {
              await app_instance.storage.delete(key: "searchCounts");
              return [];
            }
          } catch (e, stacktrace) {
            if (kDebugMode) {
              print('''Error: $e \n StackTrace: $stacktrace''');
            }
            return [];
          }
        } else {
          try {
            //PHP API
            dynamic resultData = await requestGET(
                path: 'app_get_search_list$dbtype', parameters: jsonData);
            if (resultData['status'] == true) {
              dynamic searchCounts = resultData['cnt'];
              if (searchCounts == null) {
                searchCounts = '0';
                await app_instance.storage
                    .write(key: "resetSearch", value: '1');
              }
              await app_instance.storage
                  .write(key: "searchCounts", value: searchCounts.toString());

              if (resultData['result']['data'].length > 0) {
                return parseResult(
                    resultData['result']['data'], tempData['STDCODE']);
              } else {
                return [];
              }
            } else {
              await app_instance.storage.delete(key: "searchCounts");
              return [];
            }
          } catch (e, stacktrace) {
            if (kDebugMode) {
              print('''Error: $e \n StackTrace: $stacktrace''');
            }
            return [];
          }
        }
      }

      return [];
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
      return [];
    }
  }

  Future<List<ItemModel>> fetchItemAgent(jsonData) async {
    try {
      dynamic params = await app_instance.storage.read(key: 'get_algolia');

      if (params == "{}" || params == null) {
        dynamic result =
            await requestGET(path: 'get_algolia', parameters: {'token': ''});
        await app_instance.storage
            .write(key: 'get_algolia', value: jsonEncode(result));
        params = jsonDecode(result);
      }

      final tempData = await Notify().getArguments();
      dynamic isAlgolia = false;
      String loc = '', indexName = '';
      var dbtype = '';
      if (params != null) {
        params = jsonDecode(params);
        isAlgolia = (params.containsKey('MIX_ALGOLIA_REST_API_SEARCH'))
            ? params['MIX_ALGOLIA_REST_API_SEARCH'] ?? false
            : false;
        loc = params['MIX_ALGOLIA_REST_API'];
        indexName = 'dev_property';

        dynamic testUser = await app_instance.storage.read(key: 'testUser');
        dynamic searchType = await app_instance.storage.read(key: 'searchType');

        if (testUser == 'true') {
          if (searchType != null) {
            switch (searchType) {
              case '0': //laravel sql
                {
                  dbtype = '_sql';
                  isAlgolia = false;
                  break;
                }
              case '1': //laravel alg0lia
                {
                  dbtype = '_algolia';
                  isAlgolia = false;
                  break;
                }
              case '2': //Alglolia Rest API
                {
                  isAlgolia = true;
                  break;
                }
              default:
                break;
            }
          }
        }
        if (isAlgolia) {
          //REST API Algolia
          try {
            dynamic resultData = await searchAlgoliaPost(loc, indexName,
                parameters: jsonData, isSearchAgentListing: true);
            dynamic deviceInfoJson = await getDeviceInfo();
            //activityLogApi(jsonData, deviceInfoJson);
            if (resultData.isNotEmpty) {
              dynamic searchCounts = resultData[0]['nbHits'];
              Constants.countAgent.value = int.parse(searchCounts.toString());
              if (searchCounts == null) {
                searchCounts = '0';
                await app_instance.storage
                    .write(key: "resetSearch", value: '1');
              }
              await app_instance.storage
                  .write(key: "searchCounts1", value: searchCounts.toString());

              if (resultData[0]['hits'].length > 0) {
                return parseAlgoliaResult(
                    resultData[0]['hits'], tempData['STDCODE']);
              } else {
                return [];
              }
            } else {
              await app_instance.storage.delete(key: "searchCounts1");
              return [];
            }
          } catch (e, stacktrace) {
            if (kDebugMode) {
              print('''Error: $e \n StackTrace: $stacktrace''');
            }
            return [];
          }
        } else {
          try {
            //PHP API
            dynamic resultData = await requestGET(
                path: 'agent_property_list$dbtype', parameters: jsonData);
            if (resultData['status'] == true) {
              dynamic searchCounts = resultData['cnt'];
              if (searchCounts == null) {
                searchCounts = '0';
                await app_instance.storage
                    .write(key: "resetSearch", value: '1');
              }
              await app_instance.storage
                  .write(key: "searchCounts1", value: searchCounts.toString());

              if (resultData['result']['data'].length > 0) {
                return parseResult(
                    resultData['result']['data'], tempData['STDCODE']);
              } else {
                return [];
              }
            } else {
              await app_instance.storage.delete(key: "searchCounts1");
              return [];
            }
          } catch (e, stacktrace) {
            if (kDebugMode) {
              print('''Error: $e \n StackTrace: $stacktrace''');
            }
            return [];
          }
        }
      }

      return [];
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('''Error: $e \n StackTrace: $stacktrace''');
      }
      return [];
    }
  }

  Future<List<ItemModel>> getAgentProperty(jsonData) async {
    final tempData = await Notify().getArguments();
    final resultData =
        await requestGET(path: 'app_get_search_list_sql', parameters: jsonData);
    if (resultData['status'] == true) {
      dynamic searchCounts = resultData['cnt'];
      if (searchCounts == null) {
        searchCounts = '0';
        await app_instance.storage.write(key: "resetSearch", value: '1');
      }

      if (resultData['result']['data'].length > 0) {
        return parseResult(resultData['result']['data'], tempData['STDCODE']);
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  parseAlgoliaResult(responseBody, stdCode) {
    final data = responseBody as List;
    return data.map((rawPost) {
      rec = jsonDecode(rawPost['json_data']);
      return ItemModel.recJson(rec, stdCode);
    }).toList();
  }

  Future<List<RequestModel>> requestPropList(jsonData) async {
    final resultData =
        await requestGET(path: 'subscribed_city_request', parameters: jsonData);

    if (resultData['status'] == true) {
      dynamic requestCount = resultData['cnt'];
      if (requestCount == null) {
        requestCount = '0';
      }
      await app_instance.storage
          .write(key: "requestCount", value: requestCount.toString());
      return parseResultRequest(resultData['result']['data']);
    } else {
      return [];
    }
  }

  Future<dynamic> privatePropertyList(jsonData) async {
    final resultData =
        await requestGET(path: 'get_private_property', parameters: jsonData);

    return resultData;
  }

  Future<List<RequestModel>> myRequestList(jsonData) async {
    final resultData =
        await requestGET(path: 'my-request-list-v3', parameters: jsonData);
    if (resultData['status'] == true) {
      dynamic requestCount = resultData['cnt'];
      if (requestCount == null) {
        requestCount = '0';
      }
      await app_instance.storage
          .write(key: "myRequestCount", value: requestCount.toString());
      return parseResultRequest(resultData['result']['data']);
    } else {
      return [];
    }
  }

  // Create channel data to the api
  Future<dynamic> sendChannelData(jsonData) async {
    return await requestPOST(path: 'create_channel', parameters: jsonData);
  }

  // Delete Request from my requests
  Future<dynamic> deleteRequest(jsonData) async {
    await requestPOST(path: 'my_request_delete', parameters: jsonData);
    await app_instance.storage.delete(key: 'myRequestCount');
    await app_instance.storage.write(key: 'myRequestCount', value: '0');
  }

  Future<List<ItemModel>> mypropertiesList(jsonData) async {
    final tempData = await Notify().getArguments();
    final resultData =
        await requestGET(path: 'app_myproperties_list', parameters: jsonData);
    if (resultData['status'] == true) {
      return parseResult(resultData['result']['data'], tempData['STDCODE']);
    } else {
      return [];
    }
  }

  Future<dynamic> getChannelList({
    int pageNumber = 1,
    String? channelLastSyncTime,
  }) async {
    UserModel currentUser = await app_instance.utility.jwtUser();

    if (currentUser.token.runtimeType == Null) {
      return [];
    }
    Map<String, Object> jsonData = {
      'token': currentUser.token.toString(),
      'channelLastSyncTime': channelLastSyncTime.toString()
    };
    int page = pageNumber.round();
    /*  final resultData =
        await requestGET(path: 'channel_list/$page', parameters: jsonData); */
    final resultData = await requestGET(
        path: 'get-channel-list-op/$page', parameters: jsonData);
    if (resultData != null) {
      return resultData;
    } else {
      return [];
    }
  }

  Future<List<ItemModel>> myFavoriteList(jsonData) async {
    final tempData = await Notify().getArguments();
    final resultData =
        await requestGET(path: 'app_myfavorite_list', parameters: jsonData);

    if (resultData['status'] == true) {
      return parseResult(resultData['result']['data'], tempData['STDCODE']);
    } else {
      return [];
    }
  }

  // Get block users list
  Future<Map<dynamic, dynamic>> getBlockUsers({pageNumber = 1}) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    int page = pageNumber.round();
    Map<String, Object> jsonData = {
      "token": currentUser.token.toString(),
      "page": page.toString()
    };
    final resultData =
        await requestGET(path: "get-block-users-list", parameters: jsonData);
    return resultData;
  }

  //  Bloc-Unbloc User
  Future<dynamic> blockUser(String id, String block, String channelId) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {
      'token': currentUser.token.toString(),
      'block': block.toString(),
      'channelId': channelId
    };
    final result = await requestPOST(
        path: "block-unblock-channel-users/$id", parameters: jsonData);
    return result;
  }

  Future<dynamic> getUpdatedUsers(lastUserUpdatedTimeToken) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {
      'token': currentUser.token!,
      'lastUserUpdatedTimeToken': lastUserUpdatedTimeToken.toString(),
    };
    dynamic resultData =
        await requestGET(path: 'get-updated-users', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> getUserProfile(id) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {'token': currentUser.token!};
    final resultData =
        await requestGET(path: 'get-user-profile/$id', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> getPropertyDetails(id) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {'token': currentUser.token!};
    /*   String propertyid = 'm-$id'; */
    final resultData =
        await requestGET(path: 'propertyDetails/$id', parameters: jsonData);
    return resultData;
  }

  Future<AgentDetail> agentDetail(id) async {
    final tempData = await Notify().getArguments();
    final resultData =
        await requestGETList(path: 'agentDetails/$id', parameters: {});
    return AgentDetail.recJson(resultData, tempData['STDCODE']);
  }

  parseResult(responseBody, stdCode) {
    recString = stringToBase64Url.decode(responseBody);
    recList = jsonDecode(recString!);
    final data = recList as List;
    return data.map((rawPost) {
      rec = jsonDecode(rawPost['json_data']);
      return ItemModel.recJson(rec, stdCode);
    }).toList();
  }

  parseResultRequest(responseBody) {
    recString = stringToBase64Url.decode(responseBody);
    recList = jsonDecode(recString!);
    final data = recList as List;
    return data.map((rawPost) {
      rec = jsonDecode(rawPost['json_data']);
      return RequestModel.recJson(
          rec,
          rawPost['agency_name'],
          rawPost['agency_name_ar'],
          rawPost['status'],
          rawPost['user_id'],
          rawPost['displayName'],
          rawPost['email'],
          rawPost['photo_url'],
          rawPost['channel_exist'],
          rawPost['friendlyName'],
          rawPost['channelId'],
          rawPost['created_timetoken'],
          rawPost['updated_timetoken']);
    }).toList();
  }

  getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    UserModel currentUser = await app_instance.utility.jwtUser();
    var userId = currentUser.id.toString();
    Map<String, dynamic> deviceJson;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceJson = {
        'user_id': "$userId",
        'uuid': '${iosDeviceInfo.identifierForVendor}',
        'model': '${iosDeviceInfo.model}',
        'platforms': '${iosDeviceInfo.systemName}',
        'version': '${iosDeviceInfo.systemVersion}',
        'manufacturer': 'Apple',
        'isVirtual': (iosDeviceInfo.isPhysicalDevice) ? '0' : '1',
        'serial': 'unknown'
      };
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceJson = {
        'user_id': '$userId',
        'uuid': androidDeviceInfo.id,
        'model': androidDeviceInfo.model,
        'devicePlatform': 'Android',
        'version': androidDeviceInfo.version.release,
        'manufacturer': androidDeviceInfo.brand,
        'isVirtual': (androidDeviceInfo.isPhysicalDevice) ? '0' : '1',
        'serial': 'unknown',
      };
      return deviceJson;
    }
  }

  activityLogApi(
    jsonData,
    deviceInfoJson,
  ) {
    jsonData['algolia_search'] = 'true';
    jsonData['device_info'] = deviceInfoJson.toString();

    requestGET(path: 'custom-activity', parameters: jsonData);
  }

  // get record by id
  Future<dynamic> getRequestDetails(requestId) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {'token': currentUser.token!};
    final resultData = await requestGET(
        path: 'get-request-by-id/$requestId', parameters: jsonData);
    return resultData;
  }

  // get record by created time token
  Future<dynamic> getRequestDetailsByCreatedTimeToken(createdTimeToken) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {'token': currentUser.token!};
    final resultData = await requestGET(
        path: 'get-request-by-timetoken/$createdTimeToken',
        parameters: jsonData);
    return resultData;
  }

  updateChannelFlag(String channelID) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {'token': currentUser.token!};
    final resultData = await requestPOST(
        path: 'update-chat-flag/$channelID', parameters: jsonData);
    return resultData;
  }
}
