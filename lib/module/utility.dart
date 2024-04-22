import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/isar/app_config/app_config_isar.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anytimeworkout/isar/app_config/app_config.dart' as app_config_store;
import 'package:anytimeworkout/config.dart' as app_instance;

app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();

class Utility {
  String getLocalDateFromMilliseconds(
      {required String milliseconds, bool onlyTime = false}) {
    try {
      DateFormat dateFormat;
      String padItMicroSeconds = milliseconds.toString().padRight(17, '0');
      var parsed = DateTime.fromMillisecondsSinceEpoch(
              int.parse(padItMicroSeconds) ~/ 10000,
              isUtc: true)
          .toLocal();
      if (onlyTime == true) {
        dateFormat = DateFormat.jm();
      } else {
        dateFormat = DateFormat.yMd().add_jm();
      }
      var formatted = dateFormat.format(parsed).toString();
      return formatted;
    } catch (e) {
      print('milliseconds: $milliseconds');
      return '';
    }
  }

  // Pubnub Store time in 17 digits unix time stamp precision
  String getUnixTimeStampInPubNubPrecision(
      {String? date, bool getFutureTime = false}) {
    DateTime now;
    if (date.runtimeType == Null) {
      now = DateTime.now().toUtc();
    } else {
      if (getFutureTime == false) {
        now = DateTime.parse(date!).toUtc();
      } else {
        now = DateTime.parse(date!).add(const Duration(hours: 5)).toUtc();
      }
    }

    var microsecondsSinceEpoch = now.microsecondsSinceEpoch;

    return microsecondsSinceEpoch.toString().padRight(17, '0');
  }

  String getMilisecondSinceEpocFromDate({required String mySQLDateTime}) {
    // Adjustment for database time
    DateTime date = DateTime.parse(mySQLDateTime).toUtc();
    String date1 = date.microsecondsSinceEpoch.toString();
    return date1.toString().padRight(17, '0');
  }

  String commentInterval(String previousDate) {
    final pdate = DateTime.parse(previousDate);
    var date = DateTime.now().difference(pdate);
    var timeLine = '';
    if (date.inDays != 0) {
      if (date.inDays >= 7) {
        final weeks = date.inDays / 7;
        timeLine = '${weeks.round()}w';
      } else {
        timeLine = '${date.inDays}d';
      }
    } else if (date.inHours != 0) {
      timeLine = '${date.inHours}hr';
    } else if (date.inMinutes != 0) {
      timeLine = '${date.inMinutes}min';
    } else {
      // TO DO: Temp Fix
      if (date.isNegative) {
        date = date * (-1);
      }
      timeLine = '${date.inSeconds}s';
    }
    return timeLine;
  }

  dynamic sortChannelsOnTime(List<ChatChannel> chatChannel) {
    return chatChannel.sort((a, b) {
      if (b.chatFlag == '4' || b.chatFlag == '5') {
        return 1;
      } else {
        dynamic aTime = DateTime.fromMillisecondsSinceEpoch(
                int.parse(a.lastMessageTime) ~/ 10000,
                isUtc: true)
            .toLocal();
        dynamic bTime = DateTime.fromMillisecondsSinceEpoch(
                int.parse(b.lastMessageTime) ~/ 10000,
                isUtc: true)
            .toLocal();
        return bTime.compareTo(aTime);
      }
    });
  }

  launchURL(String link) async {
    final Uri url = Uri.parse(link);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  String getMessageTimeInVariousFormat(String timetoken) {
    var now = DateTime.now();
    String padItMicroSeconds = timetoken.toString().padRight(17, '0');
    var date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(padItMicroSeconds) ~/ 10000,
            isUtc: true)
        .toLocal();
    var diff = now.difference(date);
    String time = '';

    if (diff.inHours < 12) {
      time = DateFormat.jm('en_US').format(DateTime.fromMillisecondsSinceEpoch(
              int.parse(padItMicroSeconds) ~/ 10000,
              isUtc: true)
          .toLocal());
    } else if (diff.inHours >= 12 && diff.inHours <= 24) {
      time = "chat_section.lbl_yesterday".tr();
    } else if (diff.inHours > 24) {
      time = DateFormat("dd/MM/yyyy", 'en_US').format(
          DateTime.fromMillisecondsSinceEpoch(
                  int.parse(padItMicroSeconds) ~/ 10000,
                  isUtc: true)
              .toLocal());
    }
    return time;
  }

  // Need improvement here Keeping OLD as it for now
  String getMessageTimeInVariousFormatNew(String timetoken) {
    var now = DateTime.now();
    String padItMicroSeconds = timetoken.toString().padRight(17, '0');
    var date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(padItMicroSeconds) ~/ 10000,
            isUtc: true)
        .toLocal();
    var diff = now.difference(date);
    String time = '';

    if (diff.inMicroseconds >= 0 && diff.inMilliseconds <= 60) {
      time = 'just now';
    } else if (diff.inSeconds >= 1 && diff.inSeconds < 60) {
      time = '${diff.inMinutes} seconds ago';
    } else if (diff.inMinutes >= 1 && diff.inMinutes < 60) {
      time = '${diff.inMinutes} minutes ago';
    } else if (diff.inHours >= 1 && diff.inHours < 12) {
      time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
              int.parse(padItMicroSeconds) ~/ 10000,
              isUtc: true)
          .toLocal());
    } else if (diff.inHours > 12 && diff.inHours < 24) {
      time = "Yesterday";
    } else if (diff.inHours > 24) {
      time = DateFormat("dd/MM/yyyy").format(
          DateTime.fromMillisecondsSinceEpoch(
                  int.parse(padItMicroSeconds) ~/ 10000,
                  isUtc: true)
              .toLocal());
    }
    return time;
  }

  Future<List<String>> getFileList(selectedMedia,
      [double mediaMaximumSizeInMB = 64.0,
      int maximumMediaSelectionCount = 8]) async {
    List<String> filesList = [];
    Fluttertoast.cancel();
    for (var i = 0; i < selectedMedia.length; i++) {
      if (selectedMedia[i].runtimeType.toString() == '_File') {
        final file = File(selectedMedia[i].path);
        int sizeInBytes = file.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);

        if (sizeInMb <= mediaMaximumSizeInMB &&
            i < maximumMediaSelectionCount) {
          if (sizeInMb != 0) {
            filesList.add(selectedMedia[i].path);
          } else {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (filesList.isEmpty) {
                Fluttertoast.cancel();
                Fluttertoast.showToast(
                  msg: "chat_section.lbl_file_not_exist_device".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            });
            continue;
          }
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (filesList.isEmpty) {
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                msg: "chat_section.lbl_canNot_send_media_above_64mb".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          });
          continue;
        }
      } else {
        final data = await selectedMedia[i].file;
        File file = File(data.path);
        int sizeInBytes = file.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);

        if (sizeInMb <= mediaMaximumSizeInMB) {
          filesList.add(data!.path);
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (filesList.isEmpty) {
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                msg: "chat_section.lbl_canNot_send_media_above_64mb".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          });
          continue;
        }
      }
    }
    return filesList;
  }

  // this function will return message validation in form of time diffrence
  int getOneHourMessageValidation(String lastMessageSentTime) {
    // get time diffrence -----------
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(lastMessageSentTime) ~/ 10000,
            isUtc: true)
        .toLocal();
    var diff = now.difference(date);
    var diffrence = diff.inSeconds;

    int messageTimeInterval = 180;
    int timeDiffrenceInMinutes = messageTimeInterval - diffrence;
    return timeDiffrenceInMinutes;

    // TO DO: For dyanmic settings
    // app_config_store.AppConfig appConfigStore = app_config_store.AppConfig();

    // dynamic getAppSettingsFromLocal =
    //     await appConfigStore.fetchConfig(configName: 'appSettings');

    // int messageTimeInterval = 0;
    // if (getAppSettingsFromLocal != null) {
    //   messageTimeInterval = int.parse(
    //       getAppSettingsFromLocal['PUBLIC_MESSAGE_INTERVAL'].toString());
    // } else {
    //   messageTimeInterval = 60;
    // }
    // int timeDiffrenceInMinutes = messageTimeInterval - diffrence;
    // return timeDiffrenceInMinutes;
  }

  bool validateOwnerShip(ChatChannel chatChannel) {
    bool saveFlag = false;
    if (chatChannel.channelId != "" && chatChannel != ChatChannel.empty) {
      if (int.parse(chatChannel.channelId) > 2) {
        dynamic channelData = jsonDecode(chatChannel.channelData.toString());
        List<int> chatUsers = [];
        if (channelData['chat_user'].runtimeType != Null) {
          channelData['chat_user'].entries.forEach((element) {
            chatUsers.add(int.parse(element.value.toString()));
          });
        }
        saveFlag = chatUsers.contains(int.parse(chatChannel.chatUser.userId));
      } else {
        saveFlag = true;
      }
    }

    return saveFlag;
  }

  Future<dynamic> getPropertyType() async {
    await app_instance.propertyTypeRepository.getPropertyType();
  }

  getAlgoliaKey() async {
    final cacheKey = await app_instance.storage.read(key: 'algolia_cache_key');
    Object jsonData = {'cache_key': cacheKey.toString()};
    final result = await app_instance.userRepository.getAlgoliaKey(jsonData);
    if (result['status'] == false) {
      await app_instance.storage.write(
          key: 'algolia_cache_key', value: result['cache_key'].toString());
      await app_instance.storage.write(key: "resetSearch", value: '1');
    }
  }

  getAlgolia() async {
    // Move all boot stuff here where user do not need to login
    String? prevBuildNumber =
        await app_instance.storage.read(key: 'prev_build_number');
    String? contactInfo = await app_instance.storage.read(key: 'contact_info');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await app_instance.storage
        .write(key: 'build_number', value: packageInfo.buildNumber);
    if (contactInfo.runtimeType == Null ||
        contactInfo.toString() == '{}' ||
        prevBuildNumber.runtimeType == Null ||
        prevBuildNumber != packageInfo.buildNumber) {
      await app_instance.storage
          .write(key: 'prev_build_number', value: packageInfo.buildNumber);
      Map<String, Object> jsonData = {'platformSource': 'android'};
      final response =
          await app_instance.contactRepository.checkVersion(jsonData);
      await app_instance.storage
          .write(key: 'contact_info', value: jsonEncode(response));
    }

    Object jsonData = {'token': ''};
    dynamic isData;
    dynamic params = await app_instance.storage.read(key: 'get_algolia');
    if (params.toString() == '{}' || params == null) {
      final result = await app_instance.userRepository.getAlgolia(jsonData);
      await app_instance.storage
          .write(key: 'get_algolia', value: jsonEncode(result));
      params = result;
      isData = false;
    } else {
      params = jsonDecode(params);
      isData = false;
    }
    await app_instance.appConfigStore.saveAppConfig(AppConfigIsar()
      ..configName = "get_algolia"
      ..configValue = jsonEncode(params));
    return params;
  }

  postLimit() async {
    await app_instance.storage.delete(key: 'request_location');
    bool isLogin = await Notify().checkLogin();

    if (isLogin) {
      bool isPhoneValidate = await Notify().lookup();
      await app_instance.storage.write(
          key: 'phone_number_validate', value: isPhoneValidate.toString());
    }
  }

  clearJsonLastSearchForLatestResult() async {
    await app_instance.storage.delete(key: 'jsonLastSearch');
    await app_instance.storage.delete(key: 'jsonOldSearch');
    await app_instance.storage.delete(key: 'resetSearch');
    await app_instance.storage.delete(key: 'itemSearch');
    await app_instance.storage.delete(key: 'jsonAmenitiesSearch');
    await app_instance.storage.delete(key: 'sortBy');
    await app_instance.storage.delete(key: "locationIdIndex");
    await app_instance.storage.write(key: "resetSearch", value: '1');
  }

  checkAppVersion() async {
    Map<String, Object> jsonData = {};
    if (Platform.isIOS) {
      jsonData = {
        'platformSource': 'ios',
      };
    } else {
      jsonData = {
        'platformSource': 'android',
      };
    }

    // Check for localAppSecrets and update if needed
    final appSecretsFromServer =
        await app_instance.contactRepository.checkVersion(jsonData);
    if (appSecretsFromServer.containsKey('APP_RELEASE_HASH')) {
      dynamic getAppSettingsFromLocal =
          await appConfigStore.fetchConfig(configName: 'appSettings');
      String appReleaseHashFromLocal = "0000000";

      if (getAppSettingsFromLocal != null &&
          getAppSettingsFromLocal.containsKey('APP_RELEASE_HASH')) {
        appReleaseHashFromLocal = getAppSettingsFromLocal['APP_RELEASE_HASH'];
      }
      //  appSecretsFromServer['APP_RELEASE_HASH'] = '15151515';
      if (appSecretsFromServer['APP_RELEASE_HASH'] != appReleaseHashFromLocal) {
        await app_instance.isarServices.cleanDb();
        app_instance.appConfig.maxMediaUpload =
            (appSecretsFromServer.containsKey('maxMediaUpload'))
                ? appSecretsFromServer['maxMediaUpload']
                : app_instance.appConfig.maxMediaUpload;

        app_instance.appConfig.appReleaseHash =
            (appSecretsFromServer.containsKey('APP_RELEASE_HASH'))
                ? appSecretsFromServer['APP_RELEASE_HASH']
                : app_instance.appConfig.appReleaseHash;

        app_instance.appConfigStore.saveAppConfig(AppConfigIsar()
          ..configName = "appSettings"
          ..configValue = jsonEncode(appSecretsFromServer));
      } else {
        app_instance.appConfig.appReleaseHash =
            (appSecretsFromServer.containsKey('APP_RELEASE_HASH'))
                ? appSecretsFromServer['APP_RELEASE_HASH']
                : app_instance.appConfig.appReleaseHash;
        app_instance.appConfig.maxMediaUpload =
            (appSecretsFromServer.containsKey('maxMediaUpload'))
                ? appSecretsFromServer['maxMediaUpload']
                : app_instance.appConfig.maxMediaUpload;
      }
    }
  }

  Future<UserModel> jwtUser() async {
    dynamic jwtUser = await app_instance.storage.read(key: "JWTUser");
    UserModel userModel = (jwtUser != null)
        ? UserModel.recJson(jsonDecode(jwtUser))
        : UserModel.empty;
    return userModel;
  }

  Future<UserModel> updateJwtUser(Map<String, dynamic> keyValue) async {
    dynamic getJwtUser = await app_instance.storage.read(key: "JWTUser");
    if (getJwtUser == null) {
      return UserModel.empty;
    }
    dynamic decodedJwtUser = jsonDecode(getJwtUser);

    for (var element in keyValue.entries) {
      decodedJwtUser[element.key] = element.value;
    }
    await app_instance.storage.write(
      key: "JWTUser",
      value: jsonEncode(decodedJwtUser),
    );
    UserModel userModel = await jwtUser();
    return userModel;
  }

  Future<dynamic> checkAgency() async {
    final currentUser = await jwtUser();
    (currentUser.roleId == '3' || currentUser.roleId == '2') ? true : false;
  }
}
