import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:anytimeworkout/views/screens/profile_detail/profile_detail_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import "dart:async";
import 'package:provider/provider.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class CheckLogin {
  Future<dynamic> deleteStore() async {
    // dynamic favListsGuest = await _storage.read(key: 'favListsGuest');

    dynamic favIdsGuest = await app_instance.storage.read(key: 'favIdsGuest');
    dynamic currentTime = await app_instance.storage.read(key: 'CurrentTime');
    String? stripeCustomerId =
        await app_instance.storage.read(key: 'stripeCustomerId');
    dynamic searchSavedListsGuest =
        await app_instance.storage.read(key: 'searchSavedListsGuest');
    dynamic searchIdsGuest =
        await app_instance.storage.read(key: 'searchIdsGuest');
    dynamic requestCount = await app_instance.storage.read(key: 'requestCount');
    dynamic contactInfo = await app_instance.storage.read(key: 'contact_info');

    await app_instance.storage.deleteAll();
    await app_instance.storage
        .write(key: 'stripeCustomerId', value: stripeCustomerId);
    await app_instance.storage.write(key: 'requestCount', value: requestCount);
    await app_instance.storage.write(key: 'contact_info', value: contactInfo);
    if (favIdsGuest != null) {
      // await app_instance.storage.write(key: "favListsGuest", value: favListsGuest);
      await app_instance.storage.write(key: "favIdsGuest", value: favIdsGuest);
      //   await app_instance.storage.write(key: "favLists", value: favListsGuest);
      await app_instance.storage.write(key: "favIds", value: favIdsGuest);
    }

    if (searchIdsGuest != null) {
      await app_instance.storage
          .write(key: "searchSavedListsGuest", value: searchSavedListsGuest);
      await app_instance.storage
          .write(key: "searchIdsGuest", value: searchIdsGuest);
      await app_instance.storage
          .write(key: "searchSavedLists", value: searchSavedListsGuest);
      await app_instance.storage.write(key: "searchIds", value: searchIdsGuest);
    }
    await app_instance.storage
        .write(key: "CurrentTime", value: currentTime.toString());
    await app_instance.propertyTypeRepository.getPropertyType();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  static resetForm(BuildContext context, Function reset) async {
    await app_instance.storage.delete(key: 'jsonLastSearch');
    await app_instance.storage.delete(key: 'resetSearch');
    await app_instance.storage.delete(key: 'itemSearch');
    await app_instance.storage.delete(key: 'jsonAmenitiesSearch');
    await app_instance.storage.delete(key: 'sortBy');
    await app_instance.storage.delete(key: "locationIdIndex");

    Navigator.pushNamed(context, '/search_screen').then((value) => reset());
  }

  Future<dynamic> test(BuildContext context) async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    Object jsonData = {'token': currentUser.token.toString()};
    dynamic data = await app_instance.userRepository.checkLogin(jsonData);
    if (data['status'] == false) {
      await deleteStore();
      Navigator.popUntil(
        context,
        ModalRoute.withName('/search_result'),
      );
    }
  }

  ///Check user_Id is changed or not in DB
  Future<dynamic> checkUserId(BuildContext context) async {
    return await app_instance.userRepository
        .checkUser(context.read<UserInfo>().userInfo.id);
  }

  ///Check property add limit check
  Future<dynamic> propertyLimitCheck() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    if (currentUser.token.runtimeType == Null) {
      return false;
    }
    Object jsonData = {'token': currentUser.token.toString()};
    /* dynamic data = await _userRepository.checkLogin(jsonData);
    if (data['status'] == false) {
      await CheckLogin().deleteStore();
      Navigator.popUntil(
        context,
        ModalRoute.withName('/search_result'),
      );
    }  else 
      Object jsonData = {'token': token.toString()};*/
    dynamic limitStatus =
        await app_instance.userRepository.addPropertyLimitStatus(jsonData);

    if (limitStatus['request_status'] == true) {
      await app_instance.storage.write(
          key: 'request_limit_number',
          value: limitStatus['request_limit'].toString());
      await app_instance.storage.write(
          key: 'request_status',
          value: limitStatus['request_status'].toString());
    } else {
      await app_instance.storage.write(key: 'request_status', value: 'false');
    }

    if (limitStatus['status'] == true) {
      if (limitStatus['property_limit'] != null) {
        await app_instance.storage.write(
            key: 'property_limit_number',
            value: limitStatus['property_limit'].toString());
      }
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getUserPhoneNumber() async {
    dynamic data = await app_instance.storage.read(key: 'UserPhoneNumbers');
    if (data == null) {
      UserModel currentUser = await app_instance.utility.jwtUser();
      Map<String, Object> jsonData = {
        'user_id': currentUser.id.toString(),
        'db_type': 'member',
        'token': currentUser.token.toString()
      };
      await app_instance.userRepository.getUserJwtMobiles(jsonData);
    }
  }

  Future<dynamic> updateFavirates(editflag) async {
    final chkLogin = await Notify().checkLogin();
    if (chkLogin) {
      // dynamic favLists = await app_instance.storage.read(key: 'favLists');
      UserModel currentUser = await app_instance.utility.jwtUser();
      dynamic favIds = await app_instance.storage.read(key: 'favIds');
      Map<String, Object> jsonData = {
        'edit_flag': editflag.toString(),
        'json_text': '',
        'favorite_id': favIds,
        'token': currentUser.token.toString()
      };
      await app_instance.userRepository.storeFavoriteFlutter(jsonData);
    } else {
      // dynamic favLists = await app_instance.storage.read(key: 'favLists');
      dynamic favIds = await app_instance.storage.read(key: 'favIds');
      if (editflag < 2) {
        //  await app_instance.storage.write(key: "favListsGuest", value: favLists);
        await app_instance.storage.write(key: "favIdsGuest", value: favIds);
      } else {
        //  await app_instance.storage.delete(key: "favListsGuest");
        await app_instance.storage.delete(key: "favIdsGuest");
      }
    }
  }

/* 
  Future<dynamic> updateSavedLists(editflag) async {
    final chkLogin = await Notify().checkLogin();
    if (chkLogin) {
      dynamic searchSavedLists = await app_instance.storage.read(key: 'searchSavedLists');
      dynamic token = await app_instance.storage.read(key: 'JWTToken');
      dynamic searchIds = await app_instance.storage.read(key: 'searchIds');

      Map<String, Object> jsonData = {
        'edit_flag': editflag.toString(),
        'json_text': (searchSavedLists != null) ? searchSavedLists : '',
        'search_id': (searchIds != null) ? searchIds : '',
        'token': token.toString()
      };

      await _userRepository.storeSavedFlutter(jsonData);
    } else {
      dynamic searchSavedLists = await _storage.read(key: 'searchSavedLists');
      dynamic searchIds = await _storage.read(key: 'searchIds');
      if (editflag < 2) {
        await _storage.write(
            key: "searchSavedListsGuest", value: searchSavedLists);
        await _storage.write(key: "searchIdsGuest", value: searchIds);
      } else {
        await _storage.delete(key: "searchSavedListsGuest");
        await _storage.delete(key: "searchIdsGuest");
        await _storage.delete(key: "searchSavedLists");
        await _storage.delete(key: "searchIds");
      }
    }
  } */
  Future<dynamic> updateSavedLists(editflag) async {
    final chkLogin = await Notify().checkLogin();
    if (chkLogin) {
      UserModel currentUser = await app_instance.utility.jwtUser();
      dynamic searchSavedLists =
          await app_instance.storage.read(key: 'searchSavedLists');
      dynamic searchIds = await app_instance.storage.read(key: 'searchIds');
      Map<String, Object> jsonData = {
        'edit_flag': editflag.toString(),
        'json_text': (searchSavedLists != null) ? searchSavedLists : '',
        'search_id': (searchIds != null) ? searchIds : '',
        'token': currentUser.token.toString()
      };
      await app_instance.userRepository.storeSavedFlutter(jsonData);
    } else {
      dynamic searchSavedLists =
          await app_instance.storage.read(key: 'searchSavedLists');
      dynamic searchIds = await app_instance.storage.read(key: 'searchIds');
      if (editflag < 2) {
        await app_instance.storage
            .write(key: "searchSavedListsGuest", value: searchSavedLists);
        await app_instance.storage
            .write(key: "searchIdsGuest", value: searchIds);
      } else {
        await app_instance.storage.delete(key: "searchSavedListsGuest");
        await app_instance.storage.delete(key: "searchIdsGuest");
        await app_instance.storage.delete(key: "searchSavedLists");
        await app_instance.storage.delete(key: "searchIds");
      }
    }
  }
}
