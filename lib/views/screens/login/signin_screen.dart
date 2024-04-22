import 'dart:io';
import 'dart:convert';
import 'package:anytimeworkout/bloc/login_form/login_form_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/internet/internet.dart';
import 'package:anytimeworkout/views/components/center_loader.dart';
import 'package:anytimeworkout/views/components/check_login.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../bloc/current_user_bloc/current_user_bloc.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class SigninScreen extends StatefulWidget {
  SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  LoginFormBloc? loginFormBloc;

  @override
  void initState() {
    super.initState();
    loginFormBloc = BlocProvider.of<LoginFormBloc>(context);
    app_instance.isarServices.cleanDb();
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'login.lbl_signin'.tr());
  }

  getDeviceInfo() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      Map<String, Object> iosInfo = {
        'user_id': currentUser.id!,
        'email': currentUser.email.toString(),
        'uuid': iosDeviceInfo.identifierForVendor.toString(),
        'model': iosDeviceInfo.model.toString(),
        'platforms': iosDeviceInfo.systemName.toString(),
        'version': iosDeviceInfo.systemVersion.toString(),
        'manufacturer': 'Apple',
        'isVirtual': (iosDeviceInfo.isPhysicalDevice) ? '0' : '1',
        'serial': 'unknown'
      };
      await app_instance.userRepository.getStatisticsInfo(iosInfo);
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      Map<String, Object> androidInfo = {
        'user_id': currentUser.id.toString(),
        'email': currentUser.email.toString(),
        //'uuid': androidDeviceInfo.androidId,
        'uuid': androidDeviceInfo.id,
        'model': androidDeviceInfo.model,
        'devicePlatform': 'Android',
        'version': androidDeviceInfo.version.release,
        'manufacturer': androidDeviceInfo.brand,
        'isVirtual': (androidDeviceInfo.isPhysicalDevice) ? '0' : '1',
        'serial': 'unknown',
      };
      await app_instance.userRepository.getStatisticsInfo(androidInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showLoading = false;
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: lightColor,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarColor: primaryColor,
                statusBarIconBrightness: Brightness.dark),
            elevation: 0,
            // centerTitle: true,

            leading: ModalRoute.of(context)?.canPop == true
                ? IconButton(
                    icon: Icon(
                      (context.locale.toString() == "en_US")
                          ? (Platform.isIOS)
                              ? iosBackButton
                              : backArrow
                          : (context.locale.toString() == "en_US")
                              ? (Platform.isIOS)
                                  ? iosForwardButton
                                  : forwardArrow
                              : iosForwardButton,
                      color: blackColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
            backgroundColor: lightColor,
          ),
          body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                if (state.isValid() == true) {
                  CenterLoader.show(context);
                }
              },
              onSuccess: (context, state) async {
                if (state.successResponse != '') {
                  if (state.successResponse == 'success') {
                    bool statusCheck = await CheckLogin().propertyLimitCheck();
                    bool _isPhoneValidate = await Notify().lookup();
                    await app_instance.storage.write(
                        key: 'phone_number_validate',
                        value: _isPhoneValidate.toString());

                    app_instance.appConfig.sendLoginTokenActivity = true;
                    getDeviceInfo();
                    await app_instance.storage
                        .write(key: 'refresh_request', value: 'true');
                    // await app_instance.storage.delete(key: 'jsonLastSearch');
                    // await getChannelData();
                    CenterLoader.hide(context);
                    //  Phoenix.rebirth(context);
                    app_instance.storage
                        .write(key: 'LastPage', value: "Sign In");

                    String? jwtUserToken =
                        await app_instance.storage.read(key: 'JWTUser');
                    dynamic loggedInUser =
                        UserModel.recJson(json.decode(jwtUserToken!));
                    context
                        .read<CurrentUserBloc>()
                        .add(IsAuthorized(loggedInUser));

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/search_result', (Route<dynamic> route) => false);
                  }
                }
              },
              onFailure: (context, state) {
                CenterLoader.hide(context);
                if (state.failureResponse != '') {
                  dynamic checkInternetConnection =
                      context.read<InternetBloc>().state;

                  if (checkInternetConnection.runtimeType ==
                      InternetDisconnected) {
                    Fluttertoast.showToast(
                        msg: "connection.checkConnection".tr(),
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 3);
                  } else {
                    Fluttertoast.showToast(
                        msg: "login.lbl_invalid_credentials".tr(),
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 5);
                  }
                }
              },
              child: Container(
                color: lightColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'login.lbl_signin',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: blackColor,
                            ),
                          ).tr(),
                        ]),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.2,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: pageHPadding * 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextFieldBlocBuilder(
                                textFieldBloc: loginFormBloc!.email,
                                keyboardType: TextInputType.emailAddress,
                                textStyle: const TextStyle(color: blackColor),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(right: 20.0),
                                  filled: true,
                                  fillColor: greyColor,
                                  hintText: 'login.lbl_email'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    color: blackColorLight,
                                  ),
                                  prefixIcon: const Icon(
                                    mailIcon,
                                    color: blackColorLight,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFieldBlocBuilder(
                                textFieldBloc: loginFormBloc!.password,
                                suffixButton: SuffixButton.obscureText,
                                textStyle: const TextStyle(color: blackColor),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(right: 20.0),
                                  filled: true,
                                  fillColor: greyColor,
                                  hintText: 'login.lbl_password'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    color: blackColorLight,
                                  ),
                                  prefixIcon: const Icon(
                                    lockIcon,
                                    color: blackColorLight,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: transparentColor),
                                    child: const Text(
                                            'login.lbl_forgot_password',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: primaryColor,
                                                fontWeight: FontWeight.normal))
                                        .tr(),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/forgot_password');
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 15 * unitHeight),
                              Container(
                                  height: unitWidth * 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        // foregroundColor: primaryDark,
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onPressed: loginFormBloc!.submit,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('login.lbl_signin',
                                                  style: TextStyle(
                                                      fontSize: pageIconSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: lightColor))
                                              .tr(),
                                        ]),
                                  )),
                              const SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: blackColor),
                                      child: Row(children: <Widget>[
                                        const Text('login.lbl_need_an_account',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal))
                                            .tr(),
                                        const SizedBox(width: 4),
                                        const Text('login.lbl_sign_up',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              color: primaryColor,
                                            )).tr(),
                                      ]),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/register')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
