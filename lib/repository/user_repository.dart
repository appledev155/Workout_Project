import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'repository.dart';
import 'package:anytimeworkout/isar/app_config/app_config.dart' as app_config_store;

import 'package:anytimeworkout/config.dart' as app_instance;

class UserRepository extends Repository {
  app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();

  Future<dynamic> submitLoginForm(jsonData) async {
    final resultData =
        await requestGET(path: 'app_email_login', parameters: jsonData);

    String userIdData = resultData['user']['id'].toString();
    await app_instance.utility.updateJwtUser({"id": userIdData.toString()});

    await storageData('Email', resultData);
    _getUserPhoneNumber();
    getUserJwtFavorites();
    getUserJwtSaved();
    return resultData;
  }

  Future<dynamic> loginWithSocial(jsonData) async {
    final resultData =
        await requestGET(path: 'app_social_login', parameters: jsonData);
    await storageData(jsonData['account'], resultData);
    _getUserPhoneNumber();
    getUserJwtFavorites();
    getUserJwtSaved();
    return resultData;
  }

  Future<dynamic> getUserJwtFavorites() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {'token': currentUser.token.toString()};
    final resultData =
        await requestGET(path: 'get_user_jwt_favorites', parameters: jsonData);
    await app_instance.storage.write(key: "favUpdated", value: 'true');
    await app_instance.storage.write(key: "myPropUpdated", value: 'true');

    if (resultData['status'] == 'success') {
      // await app_instance.storage.write(key: "favLists", value: resultData['json_text']);
      await app_instance.storage
          .write(key: "favIds", value: resultData['favorite_id']);
    } else {
      // dynamic favListsGuest = await app_instance.storage.read(key: 'favListsGuest');
      dynamic favIdsGuest = await app_instance.storage.read(key: 'favIdsGuest');
      if (favIdsGuest != null) {
        //   await app_instance.storage.write(key: "favLists", value: favListsGuest);
        await app_instance.storage.write(key: "favIds", value: favIdsGuest);
        if (favIdsGuest != '{"data":[]}') await storeFavorites();
      }
    }
    return resultData;
  }

  Future<dynamic> storeFavorites() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic favIds = await app_instance.storage.read(key: 'favIds');
    Map<String, Object> jsonData = {
      'edit_flag': '0',
      'json_text': '',
      'favorite_id': favIds,
      'token': currentUser.token.toString()
    };
    await storeFavoriteFlutter(jsonData);
    return true;
  }

  Future<dynamic> getUserJwtSaved() async {
    try {
      UserModel currentUser = await app_instance.utility.jwtUser();
      Map<String, Object> jsonData = {'token': currentUser.token.toString()};
      final resultData =
          await requestGET(path: 'get_user_jwt_saved', parameters: jsonData);

      if (resultData['status'] == 'success') {
        await app_instance.storage
            .write(key: "searchSavedLists", value: resultData['json_text']);
        await app_instance.storage
            .write(key: "searchIds", value: resultData['search_id']);
      } else {
        dynamic searchSavedListsGuest =
            await app_instance.storage.read(key: 'searchSavedListsGuest');
        dynamic searchIdsGuest =
            await app_instance.storage.read(key: 'searchIdsGuest');
        if (searchIdsGuest != null) {
          await app_instance.storage.write(
              key: "searchSavedListsGuest", value: searchSavedListsGuest);
          await app_instance.storage
              .write(key: "searchIds", value: searchIdsGuest);
          if (searchIdsGuest != '{"data":[]}') await storeSaved();
        }
        return resultData;
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }

  // send last visited time when we exit from app.
  storeUserLastVisitedTime({required String unreadPrivateChannelCount}) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic lastVisitedTime =
        app_instance.utility.getUnixTimeStampInPubNubPrecision();
    dynamic unreadMessageCount = unreadPrivateChannelCount;
    String? deviceTokenStored =
        await appConfigStore.fetchConfig(configName: 'deviceToken');
    if (currentUser.token != null) {
      Map<String, Object> jsonData = {
        'token': currentUser.token.toString(),
        'userLastVisitedTime': lastVisitedTime,
        'unreadMessageCount': unreadMessageCount,
        'deviceToken': deviceTokenStored.toString(),
      };
      await requestPOST(path: 'user-last-visit-time', parameters: jsonData);
    }
  }

  // send unread count and device token after login :
  loginTokenActivity({required String unreadPrivateChannelCount}) async {
    String? deviceTokenStored =
        await appConfigStore.fetchConfig(configName: 'deviceToken');
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {
      'token': currentUser.token.toString(),
      'deviceToken': deviceTokenStored.toString(),
      'unreadMessageCount': unreadPrivateChannelCount.toString()
    };
    await requestPOST(path: 'login-token-activity', parameters: jsonData);
  }

  // store current time when open the app.
  storeUserVisitedTime() async {
    String? deviceTokenStored =
        await appConfigStore.fetchConfig(configName: 'deviceToken');
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic visitedTime =
        app_instance.utility.getUnixTimeStampInPubNubPrecision();
    if (currentUser.token != null) {
      Map<String, Object> jsonData = {
        'deviceToken': deviceTokenStored.toString(),
        'token': currentUser.token.toString(),
        'visitedTime': visitedTime
      };
      await requestPOST(path: 'reset_badge_count', parameters: jsonData);
    }
  }

  Future<dynamic> storeSaved() async {
    dynamic searchSavedLists =
        await app_instance.storage.read(key: 'searchSavedLists');
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic searchIds = await app_instance.storage.read(key: 'searchIds');
    Map<String, Object> jsonData = {
      'edit_flag': '0',
      'json_text': searchSavedLists,
      'search_id': searchIds,
      'token': currentUser.token.toString()
    };
    await storeSavedFlutter(jsonData);
    return true;
  }

  Future<dynamic> appSendConfirmEmail(jsonData) async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      final resultData = await requestPOST(
          path: 'app_send_confirm_email', parameters: jsonData);
      return resultData;
    } else {
      return false;
    }
  }

  Future<dynamic> addLogs(jsonData) async {
    final resultData =
        await requestPOST(path: 'add_prop_log', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> checkLogin(jsonData) async {
    final resultData =
        await requestGET(path: 'checkLogin', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> getStripe(jsonData) async {
    final resultData =
        await requestGET(path: 'get_stripe', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> addPropertyLimitStatus(jsonData) async {
    final resultData = await requestGET(
        path: 'check_property_post_limit', parameters: jsonData);

    return resultData;
  }

  submitSettingForm(jsonData) async {
    await requestGET(path: 'app_update_setting', parameters: jsonData);
  }

  Future<dynamic> _getUserPhoneNumber() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {
      'user_id': currentUser.id.toString(),
      'db_type': 'member',
      'token': currentUser.token.toString()
    };
    getUserJwtMobiles(jsonData);
  }

  Future<dynamic> getUserJwtMobiles(jsonData) async {
    final resultData =
        await requestGET(path: 'get_user_jwt_mobiles', parameters: jsonData);
    if (resultData['status'] == 'success') await storagePhones(resultData);
    return resultData;
  }

  Future<dynamic> storagePhones(jsonObject) async {
    String jsonPhones = jsonEncode(jsonObject['result']);
    await app_instance.storage
        .write(key: "UserPhoneNumbers", value: jsonPhones);
  }

  Future<dynamic> activePhone(jsonData) async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      requestPOST(path: 'active_user_mobiles', parameters: jsonData);
      await app_instance.utility
          .updateJwtUser({"phoneNumber": jsonData['phoneNumber']});
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> storeFavoriteFlutter(jsonData) async {
    requestPOST(path: 'store_favorite_flutter', parameters: jsonData);
    return true;
  }

  Future<dynamic> storeSavedFlutter(jsonData) async {
    requestPOST(path: 'store_saved_flutter', parameters: jsonData);
    return true;
  }

  Future<dynamic> getStatisticsInfo(jsonData) async {
    requestPOST(path: 'get_statistics_info', parameters: jsonData);
    return true;
  }

  requestPropAdd(jsonData) {
    dynamic addData =
        requestPOST(path: 'request-prop-add-v2', parameters: jsonData);
  }

  Future<dynamic> getAlgolia(jsonData) async {
    final resultData =
        await requestGET(path: 'get_algolia', parameters: jsonData);
    return resultData;
  }

  Future<dynamic> getAlgoliaKey(jsonData) async {
    final resultData =
        await requestGET(path: 'get_algolia_cache', parameters: jsonData);

    return resultData;
  }

  Future<dynamic> updatePhnNumberStatus(jsonData) async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      final resultData =
          await requestPOST(path: 'nexmo_verify', parameters: jsonData);
      return resultData;
    } else {
      return false;
    }
  }

  Future<dynamic> authyRequestSms(jsonData) async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      final resultData =
          await requestPOST(path: 'authy_requestSms', parameters: jsonData);
      return resultData;
    } else {
      return false;
    }
  }

  Future<dynamic> authyVerifyToken(jsonData) async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      final resultData =
          await requestPOST(path: 'authy_verifyToken', parameters: jsonData);
      return resultData;
    } else {
      return false;
    }
  }

  Future<dynamic> getOtp(jsonData) async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      final resultData =
          await requestPOST(path: 'get_otp', parameters: jsonData);
      return resultData;
    } else {
      return false;
    }
  }

  // Api for store phone number after click on next button
  Future<dynamic> storePhoneNumberInDb(String phoneNumber) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    final ipV4 =
        await Ipify.ipv4().onError((error, stackTrace) => 'IP NOT FOUND');
    // check device info - platform ============
    var deviceInfo = DeviceInfoPlugin();
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MM-dd hh:mm a', 'en_US').format(DateTime.now());
    dynamic userDevice;
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      userDevice = jsonEncode({
        "os": "Android",
        "browser": "Device: ${androidDeviceInfo.model}",
        "ip": ipV4.toString(),
        "date": formattedDate.toString()
      });
    } else {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      userDevice = jsonEncode({
        "os": "ios",
        "browser": "Device: ${iosDeviceInfo.model}",
        "ip": ipV4.toString(),
        "date": formattedDate.toString()
      });
    }
    dynamic jsonData = {
      'token': currentUser.token.toString(),
      'phoneNumber': phoneNumber.toString(),
      'userDevice': userDevice.toString()
    };
    return await requestPOST(path: 'create-phone-number', parameters: jsonData);
  }

  // for store OTP count in db -  just increase otp count in db
  Future<dynamic> storeOtpCountInDb(String phoneNumber) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    final ipV4 =
        await Ipify.ipv4().onError((error, stackTrace) => 'IP NOT FOUND');
    // check device info - platform
    var deviceInfo = DeviceInfoPlugin();
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MM-dd hh:mm a', 'en_US').format(DateTime.now());
    dynamic userDevice;
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      userDevice = jsonEncode({
        "os": "Android",
        "browser": "Device: ${androidDeviceInfo.model}",
        "ip": ipV4.toString(),
        "date": formattedDate.toString()
      });
    } else {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      userDevice = jsonEncode({
        "os": "ios",
        "browser": "Device: ${iosDeviceInfo.model}",
        "ip": ipV4.toString(),
        "date": formattedDate.toString()
      });
    }
    dynamic jsonData = {
      'token': currentUser.token.toString(),
      'phoneNumber': phoneNumber.toString(),
      'userDevice': userDevice.toString(),
    };
    return await requestPOST(path: "update-otp-count", parameters: jsonData);
  }

  // get otp count for phone number - used for check maximum send otp limit
  Future<dynamic> getOtpCount(String phoneNumber, String userId) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic jsonData = {
      'token': currentUser.token.toString(),
      'phoneNumber': phoneNumber.toString(),
      'userId': userId.toString()
    };
    dynamic apiResponse =
        await requestPOST(path: "get-otp", parameters: jsonData);
    return apiResponse;
  }

  // Api for store OTP and Phone number when enter OTP.
  Future<dynamic> storeOTP(String phoneNumber, String otp, String requestId,
      dynamic twillioResponseJsonData) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    final ipV4 =
        await Ipify.ipv4().onError((error, stackTrace) => 'IP NOT FOUND');
    // check device info - platform
    var deviceInfo = DeviceInfoPlugin();
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MM-dd hh:mm a', 'en_US').format(DateTime.now());
    dynamic userDevice;
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      userDevice = jsonEncode({
        "os": "Android",
        "browser": "Device: ${androidDeviceInfo.model}",
        "ip": ipV4.toString(),
        "date": formattedDate.toString()
      });
    } else {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      userDevice = jsonEncode({
        "os": "ios",
        "browser": "Device: ${iosDeviceInfo.model}",
        "ip": ipV4.toString(),
        "date": formattedDate.toString(),
      });
    }
    dynamic tryOtpCount = await app_instance.storage.read(key: 'tryOtpCount');
    dynamic jsonData = {
      'token': currentUser.token.toString(),
      'phoneNumber': phoneNumber.toString(),
      'userDevice': userDevice.toString(),
      'otp_code': otp.toString(),
      "requestId": requestId,
      "jsonData": twillioResponseJsonData.toString(),
      'sendMethod': (tryOtpCount == null || tryOtpCount == "null")
          ? "Call"
          : (tryOtpCount != null && int.parse(tryOtpCount) < 2)
              ? "Twilio"
              : 'Vonage'
    };
    dynamic otpVeri =
        await requestPOST(path: "otp-verification", parameters: jsonData);
    return otpVeri;
  }

  Future<dynamic> checkUser(id) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    return await requestPOST(
        path: 'chk_db_user',
        parameters: {'user_id': '$id', 'token': '${currentUser.token}'});
  }

  Future<dynamic> isNumberValid(jsonData) async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      final resultData =
          await requestPOST(path: 'is_number_valid', parameters: jsonData);

      if (resultData['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<dynamic> checkPhoneVerified() async {
    bool netStatus = await checkInternet();
    if (netStatus) {
      UserModel currentUser = await app_instance.utility.jwtUser();
      String? userId = currentUser.id.toString();
      Map<String, Object> jsonData = {
        'user_id': userId,
        'token': currentUser.token.toString()
      };
      final resultData =
          await requestPOST(path: 'check_phoneVerified', parameters: jsonData);
      if (resultData['status'] == 'success') {
        await app_instance.utility.updateJwtUser(
          {
            "phoneVerified": "1",
            "phoneNumber": resultData['phoneNumber'].toString()
          },
        );
        Map<String, Object> jsonData1 = {
          'user_id': userId,
          'db_type': 'member',
          'token': currentUser.token.toString()
        };
        await getUserJwtMobiles(jsonData1);
        return true;
      } else {
        await app_instance.storage.delete(key: 'phoneVerified');
        await app_instance.storage.delete(key: 'UserPhoneNumbers');
        await app_instance.storage.delete(key: 'phone_number_validate');
        return false;
      }
      /* } else
        return true; */
    } else {
      return false;
    }
  }

  Future<dynamic> verifyOtp(jsonData) async {
    bool netStatus = await checkInternet();
    UserModel currentUser = await app_instance.utility.jwtUser();
    if (netStatus) {
      final resultData =
          await requestPOST(path: 'verify_otp', parameters: jsonData);
      if (resultData['status'] == 'success') {
        await app_instance.utility.updateJwtUser(
            {"phoneNumber": jsonData['phoneNumber'], "phoneVerified": '1'});
        String? userId = currentUser.id.toString();
        Object jsonData1 = {
          'user_id': userId,
          'db_type': 'member',
          'token': currentUser.token.toString()
        };
        await getUserJwtMobiles(jsonData1);
      }
      return resultData;
    } else {
      return false;
    }
  }

  // Update device token for Push notification
  updateDeviceToken(
      {required String currentDeviceToken,
      required String prevDeviceToken,
      bool isDelete = false}) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    final ipV4 =
        await Ipify.ipv4().onError((error, stackTrace) => 'IP NOT FOUND');
    // check device info - platform
    var deviceInfo = DeviceInfoPlugin();
    dynamic userDevice;
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      userDevice = jsonEncode({
        "os": "Android",
        "browser": "Device: ${androidDeviceInfo.model}",
        "ip": ipV4.toString(),
      });
    } else {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      userDevice = jsonEncode({
        "os": "ios",
        "browser": "Device: ${iosDeviceInfo.model}",
        "ip": ipV4.toString(),
      });
    }
    dynamic jsonData = {
      'token': currentUser.token.toString(),
      'currentDeviceToken': currentDeviceToken.toString(),
      'prevDeviceToken': prevDeviceToken.toString(),
      'userDevice': userDevice.toString(),
      'isDeleted': isDelete.toString()
    };
    requestPOST(path: "add-device-tokens", parameters: jsonData);
  }

  // delete my account
  deleteAccount() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Map<String, Object> jsonData = {
      'token': currentUser.token.toString(),
    };
    await requestGET(path: 'delete-my-account', parameters: jsonData);
  }

  // storage data in local storage after login
  Future<dynamic> storageData(loginBy, jsonObject) async {
    await app_instance.storage
        .write(key: 'testUser', value: jsonObject['testUser'].toString());

    await app_instance.storage.write(key: "loginBy", value: loginBy);

    await app_instance.storage.write(
        key: "propertyAreaUnit",
        value: jsonObject['user']['property_area_unit'].toString());

    await app_instance.storage
        .write(key: "userKey", value: jsonObject['user']['userkey'].toString());

    await app_instance.storage
        .write(key: "JWTUser", value: jsonEncode(jsonObject['user']));
  }
}
