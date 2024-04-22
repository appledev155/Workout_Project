import 'dart:io';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/highlight_media/highlight.dart';
import 'package:anytimeworkout/isar/highlight_media/highlightoperation.dart'
    as highlight_store;
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/settings_page/subpages/beacon/beacon.dart';
import 'package:anytimeworkout/module/settings_page/subpages/contacts/contacts.dart';
import 'package:anytimeworkout/module/settings_page/subpages/data_permission/dataPermission.dart';
import 'package:anytimeworkout/module/settings_page/subpages/default_map/default_map.dart';
import 'package:anytimeworkout/module/settings_page/subpages/display/display.dart';
import 'package:anytimeworkout/module/settings_page/subpages/email_notifications/email_notification.dart';
import 'package:anytimeworkout/module/settings_page/subpages/feed_ordering/feed_ordering.dart';
import 'package:anytimeworkout/module/settings_page/subpages/legal/legal.dart';
import 'package:anytimeworkout/module/settings_page/subpages/link_other_device/other_services.dart';
import 'package:anytimeworkout/module/settings_page/subpages/partner_integration/partner_integration.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/push_notification.dart';
import 'package:anytimeworkout/module/settings_page/subpages/weather/weather.dart';
import 'package:anytimeworkout/views/components/check_internet.dart';
import 'package:anytimeworkout/views/components/check_login.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:anytimeworkout/views/screens/main_layout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isLoginBy = false;
  bool isPhoneVerified = false;
  bool isEmailVerified = false;
  bool isInternet = false;
  String? isTestUser;

  final Uri communityurl = Uri.parse('https://communityhub.strava.com/');
  Future<void> _launchcommunityurl() async {
    if (!await launchUrl(communityurl)) {
      throw Exception('could not launch $communityurl');
    }
  }

  String _groupValue = '';
  void checkradio(value) {
    _groupValue = value;
    Navigator.of(context).pop();
  }

  highlight_store.HighlightOperation highlightstore =
      highlight_store.HighlightOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckLogin().test(context);
    CheckLogin().getUserPhoneNumber();
    _getLoginBy();
    checkInternet();
    gethighlightdata();
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

  gethighlightdata() async {
    List<Highlight> getdata = await highlightstore.gethighlightdata();
    print(getdata);
    if (getdata.isNotEmpty) {
      setState(() {
        _groupValue =
            (getdata.first.Highlightselectvalue == "Media") ? "Media" : "Map";
        print(_groupValue);
      });
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: lightColor,
            child: Column(
              children: [
                Container(
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
                              const Divider(indent: 70, thickness: 1),
                              // const SizedBox(height: 10.0),
                            ]
                          ]),
                        ))),
                const Divider(
                  thickness: 15,
                  color: greyColor,
                ),
                Container(
                  color: lightColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(
                            'Account',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: drawerMenuItemSize,
                                fontWeight: FontWeight.w500),
                          ).tr(),
                          contentPadding:
                              const EdgeInsets.only(left: 18, top: 10),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: lightColor,
                                  foregroundImage:
                                      AssetImage('assets/images/app-icon.png'),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text(
                                      'Your AnyTime Workout Subscription',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: pageIconSize,
                                          color: blackColor),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 2, 0, 0),
                                    child: Text(
                                      'Explore and manage your subscription',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: pageIconSize,
                                          color: blackColor),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: -4.0, vertical: -3.0),
                            title: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: Text(
                                'Restore Purchases',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: pageIconSize,
                                    color: blackColorDark),
                              ).tr(),
                            ),
                            onTap: () {}),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: ListTile(
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -3.0),
                          title: Transform.translate(
                            offset: const Offset(-16, 0),
                            child: Text(
                              'Link Other Services',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ).tr(),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherServicePage()));
                          },
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: ListTile(
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -3.0),
                          title: Transform.translate(
                            offset: const Offset(-16, 0),
                            child: Text(
                              'Change Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ).tr(),
                          ),
                          onTap: () {},
                        ),
                      ),
                      const Divider(
                        thickness: 15,
                        color: greyColor,
                      )
                    ],
                  ),
                ),
                Container(
                  color: lightColor,
                  //  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(
                            'Preferences',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: pageTitleSize,
                                fontWeight: FontWeight.w500),
                          ).tr(),
                          contentPadding:
                              const EdgeInsets.only(left: 18, top: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: ListTile(
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -3.0),
                          title: Transform.translate(
                            offset: const Offset(-16, 0),
                            child: Text(
                              'Privacy Controls',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PrivacyControlPage()));
                          },
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => Container(
                                      child: AlertDialog(
                                        title: Text(
                                          'Default Highlight Media',
                                          style: TextStyle(
                                              fontSize: pageIconSize,
                                              color: primaryDark),
                                        ),
                                        actions: [
                                          RadioListTile(
                                            activeColor: primaryColor,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: const Text('Media'),
                                            value: 'Media',
                                            groupValue: _groupValue,
                                            onChanged: (value) => setState(() {
                                              checkradio(value as String);
                                              Highlight highlightdata =
                                                  Highlight(
                                                      id: 1,
                                                      Highlightselectvalue:
                                                          _groupValue);
                                              highlightstore
                                                  .insert(highlightdata);
                                              print(highlightstore
                                                  .insert(highlightdata));
                                            }),
                                          ),
                                          RadioListTile(
                                            activeColor: Colors.orange.shade800,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: const Text('Map'),
                                            value: 'Map',
                                            groupValue: _groupValue,
                                            onChanged: (value) => setState(() {
                                              checkradio(value as String);
                                              Highlight highlightdata =
                                                  Highlight(
                                                      id: 1,
                                                      Highlightselectvalue:
                                                          _groupValue);
                                              highlightstore
                                                  .insert(highlightdata);
                                              print(highlightstore
                                                  .insert(highlightdata));
                                            }),
                                          )
                                        ],
                                      ),
                                    ));
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Default Highlight Media',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: pageIconSize,
                                          color: blackColorDark),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 3, 10, 3),
                                      color: primaryColorLight,
                                      child: Text(
                                        _groupValue,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 8),
                                child: Text(
                                  'Highlight the map or media to represent your uploaded activities in the feed.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: blackColorLight),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FeedOrderingPage()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Feed Ordering',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: pageIconSize,
                                      color: blackColorDark),
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 3, 0, 8),
                                  child: Text(
                                    'Change how activities are ordered in your feed.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        color: blackColorLight),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DisplayPage()));
                        },
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Display',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PushNotificationPage()));
                        },
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Push Notifications',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailNotificationPage()));
                          _onLoading();
                        },
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Email Notifications',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ContactPage()));
                        },
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Contacts',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DataPermission()));
                        },
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Data Permissions',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LegalPage()));
                        },
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Legal',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'About',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 50, 0),
                                        child: Text(
                                          'Are you sure you want to log out?',
                                          style: TextStyle(
                                              fontSize: pageIconSize,
                                              color: blackColorDark),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontSize: pageIconSize,
                                                    color: primaryColor),
                                              )),
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Log out',
                                                style: TextStyle(
                                                    fontSize: pageIconSize,
                                                    color: primaryColor),
                                              ))
                                        ],
                                      )
                                    ],
                                  ));
                        },
                        child: Container(
                          color: lightColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: pageIconSize,
                                  color: blackColorDark),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLoading() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: CircularProgressIndicator(
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
    });
  }
}
