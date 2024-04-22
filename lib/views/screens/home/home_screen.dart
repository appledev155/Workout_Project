import 'dart:io';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/views/components/check_internet.dart';
import 'package:anytimeworkout/views/screens/profile_detail/profile_detail_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../config/icons.dart';
import '../../../views/components/notify.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../views/screens/main_layout.dart';
import '../../../config/app_colors.dart';
import '../../../views/components/check_login.dart';
import 'dart:convert';

import 'package:anytimeworkout/config.dart' as app_instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _playStoreLink = dotenv.env['PLAYSTORELINK'];
  final _appStoreLink = dotenv.env['APPSTORELINK'];

  bool isLogin = false;
  bool isPhoneValid = false;
  String status = '';
  String postLimitNumber = '';
  bool isInternet = false;

  @override
  void initState() {
    super.initState();

    context.read<UserInfo>().getUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      timeCheck();
      checkInternet();
      _checkLogin();
      checkNumber();
    });
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

  checkNumber() async {
    final chkLogin = await Notify().checkLogin();
    if (chkLogin) await Notify().checkAllNumber();
  }

  Future<bool> _checkLogin() async {
    isLogin = await Notify().checkLogin();
    setState(() {});
    return isLogin;
  }

  timeCheck() async {
    var curTime = await app_instance.storage.read(key: 'CurrentTime');
    DateTime currentTime = DateTime.now();

    if (curTime != null) {
      DateTime checkedTime = DateTime.parse(curTime.toString());
      final diff = currentTime.difference(checkedTime).inHours;
      if (diff > 2) {
        await app_instance.storage
            .write(key: "CurrentTime", value: currentTime.toString());
        versionCheck();
      }
    } else {
      await app_instance.storage
          .write(key: "CurrentTime", value: currentTime.toString());
      versionCheck();
    }
  }

  _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    await CheckLogin().deleteStore();

    if (await canLaunchUrl(uri)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  versionCheck() async {
    final _version = await app_instance.storage.read(key: 'build_number');
    Map<String, Object> jsonData = {};
    if (Platform.isIOS) {
      jsonData = {
        'platformSource': 'ios',
        'appstoreVersion': '$_version',
      };
    } else {
      jsonData = {
        'platformSource': 'android',
        'playstoreVersion': '$_version',
      };
    }
    final response =
        await app_instance.contactRepository.checkVersion(jsonData);
    await app_instance.storage
        .write(key: 'contact_info', value: jsonEncode(response));
    if (response['status'] == false) {
      _ackAlert(context);
    }
  }

  Future _ackAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text('checkVersion.headTitle'.tr()),
                content: Text('checkVersion.textMsg'.tr()),
                actions: <Widget>[
                  TextButton(
                    child: Text('checkVersion.yesText'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchURL(_appStoreLink!);
                    },
                  ),
                  TextButton(
                    child: Text('checkVersion.noText'.tr()),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : AlertDialog(
                title: Text('checkVersion.headTitle'.tr()),
                content: Text('checkVersion.textMsg'.tr()),
                actions: [
                  TextButton(
                    child: Text('checkVersion.noText'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('checkVersion.yesText'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchURL(_playStoreLink!);
                    },
                  )
                ],
              );
      },
    );
  }

  /* _checkLoginRequest(context) async {
    if (isLogin == true)
      Navigator.pushNamed(context, '/add_request');
    else
      Navigator.pushNamed(context, '/login');
    return isLogin;
  } */

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
    return MainLayout(
      color: false,
      appBarTitle: 'tabs.lbl_home'.tr(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'appName.app_title',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                color: lightColor,
              ),
            ).tr(),
            const SizedBox(height: 8),
            Text(
              'home.lbl_site_keywords',
              style: TextStyle(
                fontSize: pageTitleSize,
                fontWeight: FontWeight.normal,
                color: lightColor,
              ),
            ).tr(),
            const SizedBox(height: 15),
            Container(
                color: Colors.transparent,
                width: deviceWidth / 1.2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: lightColor),
                      ),
                      backgroundColor: lightColor),
                  icon: Icon(
                    searchIcon,
                    color: blackColor,
                    size: pageIconSize,
                  ),
                  label: Text('home.lbl_lets_search',
                          style: TextStyle(
                              color: blackColor, fontSize: pageIconSize))
                      .tr(),
                  onPressed: () => CheckLogin.resetForm(context, () {}),
                )),
            Container(
                color: Colors.transparent,
                width: deviceWidth / 1.2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: lightColor),
                    ),
                    backgroundColor: lightColor,
                  ),
                  icon: Icon(
                    addCircleIcon,
                    color: blackColor,
                    size: pageIconSize,
                  ),
                  label: Text(
                    'home.lbl_add_property',
                    style: TextStyle(color: blackColor, fontSize: pageIconSize),
                  ).tr(),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/add_property_type'),
                ))
          ],
        ),
      ),
    );
  }
}
