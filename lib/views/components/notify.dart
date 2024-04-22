import 'dart:convert';

import 'package:anytimeworkout/config/constant.dart';
import 'package:anytimeworkout/model/user_model.dart';

import '../../config/app_colors.dart';
import "dart:async";
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class Notify {
  bool isLogin = false;
  bool isPhoneValid = false;
  Future<dynamic> lookup() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    final isNewNumber = await app_instance.storage.read(key: 'isNewNumber');
    isPhoneValid = (currentUser.phoneVerified.toString() == '1') ? true : false;
    isLogin = await checkLogin();

    bool response = true;
    if (!isLogin) {
      response = false;
    }
    if ((isLogin && !isPhoneValid)) {
      try {
        response = false;
        response = await app_instance.userRepository.checkPhoneVerified();
        if (response) {
          Fluttertoast.showToast(
              msg: 'settings.phone_success_msg'.tr(),
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              backgroundColor: activeColor);
        } else if (isNewNumber == 'true') {
          await app_instance.storage.delete(key: 'isNewNumber');
          await checkValidNumber();
        }
      } catch (e, _) {
        print(e);
        print(_);
        print("Exception");
      }
    }
    return response;
  }

  Future<dynamic> checkLogin() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    if (currentUser != UserModel.empty &&
        currentUser.id != 0 &&
        currentUser.token != null) {
      return true;
    } else {
      return false;
    }
  }

  dynamic getArguments() async {
    dynamic result = await app_instance.storage.read(key: 'contact_info');
    if (result.toString() == '{}' || result.runtimeType == Null) {
      await app_instance.utility.getAlgolia();
      result = await app_instance.storage.read(key: 'contact_info');
    }
    dynamic rec = json.decode(result.toString());
    return rec;
  }

  Future<dynamic> checkAllNumber() async {
    bool response = false;
    final isNewNumber = await app_instance.storage.read(key: 'isNewNumber');
    response = await app_instance.userRepository.checkPhoneVerified();
    if (response) {
      if (isNewNumber == 'true') {
        await app_instance.storage.delete(key: 'isNewNumber');
        bool status = await checkValidNumber();
        if (status) messageNotify(status);
        return response;
      }
    }
  }

  Future<dynamic> checkValidNumber() async {
    try {
      bool response = false;
      UserModel currentUser = await app_instance.utility.jwtUser();
      String? userId = currentUser.id.toString();
      String? phoneNumber =
          await app_instance.storage.read(key: 'isValidNumber');
      Map<String, Object> jsonData = {
        'user_id': userId,
        'phoneNumber': phoneNumber!,
        'token': currentUser.token.toString()
      };

      if (phoneNumber.isEmpty) {
        response = await app_instance.userRepository.isNumberValid(jsonData);
        return response;
      } else {
        return false;
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }

  void messageNotify(bool response) async {
    if (response) {
      Constants.isFailed.sink.add("true");
      Fluttertoast.showToast(
          msg: 'settings.phone_success_msg'.tr(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: activeColor);
      await app_instance.storage.delete(key: 'isValidNumber');
    } else {
      Constants.isFailed.sink.add("false");
      Fluttertoast.showToast(
          msg: "settings.lbl_not_able_to_verify_phoneNumber".tr(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5);
    }
  }
}
