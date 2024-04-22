import 'dart:io';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/views/components/check_internet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../views/components/notify.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main_layout.dart';
import '../../../views/components/check_login.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLoginBy = false;
  bool isPhoneVerified = false;
  bool isEmailVerified = false;
  bool isInternet = false;
  String? isTestUser;

  @override
  void initState() {
    super.initState();
    CheckLogin().test(context);
    CheckLogin().getUserPhoneNumber();
    _getLoginBy();
    checkInternet();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final checkInternet =
            await app_instance.connectivity.checkConnectivity();
        if (checkInternet == ConnectivityResult.none) noNetWork();
      }
    } on SocketException catch (_) {
      noNetWork();
    }
  }

  Future<bool> _getLoginBy() async {
    final loginBy = await app_instance.storage.read(key: 'loginBy');
    UserModel currentUser = await app_instance.utility.jwtUser();
    isTestUser = await app_instance.storage.read(key: 'testUser');

    bool isLogin = await Notify().checkLogin();

    isLoginBy = (loginBy == 'Email') ? true : false;
    isEmailVerified =
        (currentUser.emailVerified.toString() == '1') ? true : false;
    isPhoneVerified =
        (currentUser.phoneVerified.toString() == '1') ? true : false;
    setState(() {
      isLoginBy = isLoginBy;
      isPhoneVerified = isPhoneVerified;
      isEmailVerified = isEmailVerified;
    });

    if (isLogin) {
      await Notify().checkAllNumber();
    }
    return isLoginBy;
  }

  noNetWork() {
    if (!isInternet) {
      Fluttertoast.showToast(
          msg: "connection.checkConnection".tr(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3);
      isInternet = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.Offline) noNetWork();
    return WillPopScope(
      onWillPop: () async {
        if (app_instance.appConfig.setHomeScreenRoute == true) {
          Navigator.pushNamed(context, '/search_result');
          app_instance.appConfig.setHomeScreenRoute = false;
        } else {
          Navigator.of(context).popUntil(ModalRoute.withName('/search_result'));
        }
        return true;
      },
      child: MainLayout(
        color: true,
        ctx: 3,
        status: 1,
        appBarTitle: 'settings.lbl_settings'.tr(),
        // appBarAction: [
        //   Align(
        //     alignment: Alignment.centerRight,
        //     child: Container(
        //       margin: const EdgeInsets.only(bottom: 5),
        //       height: unitWidth * 40,
        //       padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        //       child: UserImage(
        //           chatUser: context.read<CurrentUserBloc>().state.chatUser),
        //     ),
        //   )
        // ],
        child:  Container(
                    // color: lightColor,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                            Container(
                              child: ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                title: Text(
                                  'settings.lbl_account_settings',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: drawerMenuItemSize,
                                      fontWeight: FontWeight.w500),
                                ).tr(),
                                contentPadding:
                                    const EdgeInsets.only(left: 18, top: 10),
                              ),
                            ),

                            ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: -4.0, vertical: -3.0),
                                leading: Image.asset("assets/icon/info.png",
                                    height: 20,
                                    width: 20,
                                    opacity: const AlwaysStoppedAnimation(.3)),
                                title: Transform.translate(
                                  offset: const Offset(-16, 0),
                                  child: Text(
                                    'settings.lbl_basic_information',
                                    style: TextStyle(
                                        fontSize: pageIconSize,
                                        color: blackColorDark),
                                  ).tr(),
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, '/basic_info')),

                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -3.0),
                              leading: Image.asset("assets/icon/phone.png",
                                  height: 20,
                                  width: 20,
                                  opacity: const AlwaysStoppedAnimation(.3)),
                              title: Transform.translate(
                                offset: const Offset(-16, 0),
                                child: Text(
                                  'settings.lbl_phone_numbers',
                                  style: TextStyle(
                                      fontSize: pageIconSize,
                                      color: blackColorDark),
                                ).tr(),
                              ),
                              onTap: () {
                                if (isPhoneVerified) {
                                  Navigator.pushNamed(
                                      context, '/verfied_numbers');
                                }
                                if (!isPhoneVerified) {
                                  Navigator.pushNamed(
                                      context, '/add_new_number');
                                }
                              },
                            ),

                            // Delete my account

                            ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: -4.0, vertical: -3.0),
                                leading: Image.asset("assets/icon/delete.png",
                                    height: 20,
                                    width: 20,
                                    opacity: const AlwaysStoppedAnimation(.3)),
                                title: Transform.translate(
                                  offset: const Offset(-16, 0),
                                  child: Text(
                                    'settings.lbl_delete_account',
                                    style: TextStyle(
                                        fontSize: pageIconSize,
                                        color: blackColorDark),
                                  ).tr(),
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, '/delete_account')),
                            const SizedBox(height: 5.0),
                            // const Divider(indent: 70, thickness: 1),
                            const SizedBox(height: 5),
                            if (isLoginBy && isEmailVerified) ...[
                              ListTile(
                                title: Text(
                                  'settings.lbl_security_settings',
                                  style: TextStyle(
                                      fontSize: drawerMenuItemSize,
                                      fontWeight: FontWeight.w500,
                                      color: blackColorDark),
                                ).tr(),
                                contentPadding: const EdgeInsets.only(left: 0),
                              ),
                              ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: -4.0, vertical: -3.0),
                                leading:
                                    const Icon(keyIcon, color: primaryColor),
                                title: Text(
                                  'settings.lbl_change_password',
                                  style: TextStyle(
                                      fontSize: pageIconSize,
                                      color: blackColorLight),
                                ).tr(),
                                onTap: () => Navigator.pushNamed(
                                    context, '/change_password'),
                              ),
                            ],
                            const Divider(
                              thickness: 15,
                              color: greyColor,
                            ),
                            Container(
                              child: ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                title: Text(
                                  'settings.lbl_privacy_settings',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: drawerMenuItemSize,
                                      fontWeight: FontWeight.w500),
                                ).tr(),
                                contentPadding:
                                    const EdgeInsets.only(left: 18, top: 10),
                              ),
                            ),

                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -3.0),
                              leading: Image.asset("assets/icon/block.png",
                                  height: 20,
                                  width: 20,
                                  opacity: const AlwaysStoppedAnimation(.3)),
                              title: Transform.translate(
                                offset: const Offset(-16, 0),
                                child: Text(
                                  'settings.lbl_blocked_users',
                                  style: TextStyle(
                                      fontSize: pageIconSize,
                                      color: blackColorDark),
                                ).tr(),
                              ),
                              onTap: () => Navigator.pushNamed(
                                  context, '/blocked_users'),
                            ),
                            // const Divider(indent: 70, thickness: 1),
                            const SizedBox(height: 10.0),
                            if (isTestUser == 'true') ...[
                              ListTile(
                                leading:
                                    const Icon(searchIcon, color: primaryDark),
                                visualDensity: const VisualDensity(
                                    horizontal: -1.0, vertical: -3.0),
                                title: Text("settings.lbl_search_api",
                                        style: TextStyle(
                                            fontSize: pageIconSize,
                                            color: primaryDark))
                                    .tr(),
                                onTap: () => Navigator.pushNamed(
                                    context, '/search_api_screen'),
                              ),
                              // const Divider(indent: 70, thickness: 1),
                              // const SizedBox(height: 10.0),
                            ],
                              const Divider(
                              thickness: 15,
                              color: greyColor,
                            )
                          ]),
                        ))),
      ),
    );
  }
}
