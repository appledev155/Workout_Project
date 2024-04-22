import 'dart:io';
import 'dart:convert';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/bloc/chat/chat_bloc.dart';
import 'package:anytimeworkout/views/components/custom_web_view_screen.dart';
import 'package:anytimeworkout/views/screens/login/signin_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../../../views/components/check_login.dart';
import '../../../views/components/notify.dart';
import '../../../config/icons.dart';
import '../../../config/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../../../views/components/center_loader.dart';
import '../../../bloc/login_form/login_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginFormBloc? loginFormBloc;
  dynamic? currentUserBlocRead;
  bool isApple = false;
  dynamic tempData;
  final privacyPolicyLink = dotenv.env['PRIVACYPOLICYLINK'];
  final termsConditionsLink = dotenv.env['TERMSCONDITIONSLINK'];

  @override
  void initState() {
    super.initState();
    _isApple();
    loginFormBloc = BlocProvider.of<LoginFormBloc>(context);
    app_instance.isarServices.cleanDb();
  }

  getDeviceInfo() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      Map<String, Object> iosInfo = {
        'user_id': currentUser.id.toString(),
        'email': currentUser.email.toString(),
        'uuid': iosDeviceInfo.identifierForVendor!,
        'model': iosDeviceInfo.model!,
        'platforms': iosDeviceInfo.systemName!,
        'version': iosDeviceInfo.systemVersion!,
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

  Future<bool> get appleSignInAvailable => TheAppleSignIn.isAvailable();

  Future<bool> _isApple() async {
    tempData = await Notify().getArguments();
    bool isApple = await appleSignInAvailable;
    setState(() {
      this.isApple = isApple;
    });
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Login Screen');
    return isApple;
  }

  Future<dynamic> redirectUser(response) async {
    if (response) {
      String? jwtUserToken = await app_instance.storage.read(key: 'JWTUser');
      dynamic loggedInUser = UserModel.recJson(json.decode(jwtUserToken!));

      // This function called after social login done. (Apple, Google, Facebook)
      // ignore: use_build_context_synchronously
      // context.read<ChannelBloc>().add(ChannelResetState());
      // ignore: use_build_context_synchronously
      context.read<CurrentUserBloc>().add(const IsAuthorized(UserModel.empty));
      if (currentUserBlocRead.runtimeType != Null) {
        currentUserBlocRead.add(IsAuthorized(loggedInUser));
      }

      bool statusCheck = await CheckLogin().propertyLimitCheck();
      bool _isPhoneValidate = await Notify().lookup();
      await app_instance.storage.write(
          key: 'phone_number_validate', value: _isPhoneValidate.toString());
      getDeviceInfo();
      await app_instance.storage.write(key: 'refresh_request', value: 'true');
      CenterLoader.hide(context);
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/search_result', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: lightColor,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarColor: lightColor,
                statusBarIconBrightness: Brightness.dark),
            leading: ModalRoute.of(context)?.canPop == true
                ? IconButton(
                    icon: Icon(
                      (context.locale.toString() == "en_US")
                          ? (Platform.isIOS)
                              ? iosBackButton
                              : backArrow
                          : iosForwardButton,
                      color: lightColor,
                    ),
                    onPressed: () async {
                      return Navigator.of(context).pop();
                    },
                  )
                : null,
          ),
          body: FormBlocListener<LoginFormBloc, String, String>(
            onSubmitting: (context, state) {
              CenterLoader.show(context);
            },
            onSuccess: (context, state) async {
              if (state.successResponse != '') {
                if (state.successResponse == 'success') {
                  print(
                      "from ************** after login ${state.successResponse}");
                  context.read<ChatBloc>().add(const ResetChat());
                  context.read<ChannelBloc>().add(ChannelResetState());
                  bool statusCheck = await CheckLogin().propertyLimitCheck();
                  bool _isPhoneValidate = await Notify().lookup();
                  await app_instance.storage.write(
                      key: 'phone_number_validate',
                      value: _isPhoneValidate.toString());
                  getDeviceInfo();
                  await app_instance.storage
                      .write(key: 'refresh_request', value: 'true');
                  CenterLoader.hide(context);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/search_result', (Route<dynamic> route) => false);
                }
              }
            },
            onFailure: (context, state) {
              CenterLoader.hide(context);
              if (state.failureResponse != '') {
                Fluttertoast.showToast(
                    msg: state.failureResponse!,
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 5);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: pageHPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'login.lbl_login_welcome',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: lightColor,
                          ),
                        ).tr(),
                        const SizedBox(width: 5),
                        const Text(
                          'appName.app_title',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: lightColor,
                          ),
                        ).tr(),
                      ]),
                  const SizedBox(height: 40.0),
                  /* TextFieldBlocBuilder(
                  cursorColor: lightColor,
                  textFieldBloc: loginFormBloc.email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: lightColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: lightColor, width: 1.5)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: lightColor, width: 1.5)),
                    hintText: 'login.lbl_email'.tr(),
                    hintStyle: TextStyle(
                      color: lightColor,
                    ),
                    prefixIcon: Icon(
                      mailIcon,
                      color: lightColor,
                    ),
                  ),
                ),
                TextFieldBlocBuilder(
                  cursorColor: lightColor,
                  textFieldBloc: loginFormBloc.password,
                  suffixButton: SuffixButton.obscureText,
                  style: TextStyle(
                    color: lightColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: lightColor, width: 1.5)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: lightColor, width: 1.5)),
                    hintText: 'login.lbl_password'.tr(),
                    hintStyle: TextStyle(
                      color: lightColor,
                    ),
                    prefixIcon: Icon(
                      lockIcon,
                      color: lightColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(primary: lightColor),
                      child: Text('login.lbl_forgot_password',
                              style: TextStyle(fontSize: 15, color: lightColor))
                          .tr(),
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                    ),
                  ],
                ), */
                  _buildEmailSigninButton(),
                  const SizedBox(height: 11),
                  const Text('login.lbl_or',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColorLight))
                      .tr(),
                  const SizedBox(height: 11),
                  _buildFacebookSigninButton(),
                  const SizedBox(height: 10),
                  _buildGoogleSigninButton(),
                  if (this.isApple) const SizedBox(height: 10),
                  if (this.isApple) _buildAppleSigninButton(),
                  SizedBox(height: 20 * unitHeight),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: RichText(
                        textAlign: TextAlign.center,
                        strutStyle: const StrutStyle(height: 1.5),
                        text: TextSpan(
                            text: '${'app.lbl_by_using'.tr()} ',
                            style: TextStyle(
                              color: primaryColorLight,
                              fontFamily: 'DM Sans',
                              fontSize: pageTextSize,
                            ),
                            children: [
                              TextSpan(
                                  text: '${'appName.app_title'.tr()} ',
                                  style: TextStyle(
                                      color: primaryColorLight,
                                      fontSize: pageIconSize,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'DM Sans')),
                              TextSpan(text: '${'app.lbl_you_agree'.tr()} '),
                              TextSpan(
                                  text: 'app.lbl_terms_of_use'.tr(),
                                  style: TextStyle(
                                      color: primaryColorLight,
                                      fontSize: pageIconSize,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'DM Sans'),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CustomWebViewScreen(
                                              title:
                                                  'app.lbl_terms_of_use'.tr(),
                                              // html: (tempData[
                                              //             'TERMSCONDITIONSLINK'] !=
                                              //         null)
                                              //     ? tempData[
                                              //         'TERMSCONDITIONSLINK']
                                              //     : termsConditionsLink,
                                            ),
                                          ),
                                        )),
                              TextSpan(
                                text: ' ${'app.lbl_and'.tr()} ',
                                style: TextStyle(
                                  color: primaryColorLight,
                                  fontFamily: 'DM Sans',
                                  fontSize: pageTextSize,
                                ),
                              ),
                              TextSpan(
                                  text: 'app.lbl_privacy_policy'.tr(),
                                  style: TextStyle(
                                      color: primaryColorLight,
                                      fontSize: pageIconSize,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'DM Sans'),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CustomWebViewScreen(
                                              title:
                                                  'app.lbl_privacy_policy'.tr(),
                                              // html: (tempData[
                                              //             'PRIVACYPOLICYLINK'] !=
                                              //         null)
                                              //     ? tempData['PRIVACYPOLICYLINK']
                                              //     : privacyPolicyLink,
                                            ),
                                          ),
                                        ))
                            ])),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildEmailSigninButton() => Container(
      width: deviceWidth / 1.2,
      height: unitWidth * 40,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: lightColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<LoginFormBloc>(
                create: (context) => LoginFormBloc(),
                child: SigninScreen(),
              ),
            ),
          );
          //  Navigator.pushNamed(context, '/signin');
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('login.lbl_login_by_email',
                      style:
                          TextStyle(color: blackColor, fontSize: pageIconSize))
                  .tr(),
            ]),
      ));

  Widget _buildFacebookSigninButton() => Container(
      width: deviceWidth / 1.2,
      height: unitWidth * 40,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: lightColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: () async {
          CenterLoader.show(context);
          final res = await loginFormBloc!.signInWithFacebook();
          redirectUser(res);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icon/facebook.png',
                color: blueColor,
                height: 25,
              ),
              const SizedBox(width: 7),
              Text('login.lbl_login_by_facebook',
                      style:
                          TextStyle(color: blackColor, fontSize: pageIconSize))
                  .tr(),
            ]),
      ));

  Widget _buildGoogleSigninButton() => Container(
      width: deviceWidth / 1.2,
      height: unitWidth * 40,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: lightColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: () async {
          CenterLoader.show(context);
          final res = await loginFormBloc!.signInWithGoogle();
          redirectUser(res);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/icon/google.png',
            height: 25,
          ),
          const SizedBox(width: 7),
          Text(
            'login.lbl_login_by_google',
            style: TextStyle(color: blackColor, fontSize: pageIconSize),
          ).tr()
        ]),
      ));

  Widget _buildAppleSigninButton() => Container(
      width: deviceWidth / 1.2,
      height: unitWidth * 40,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: lightColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: () async {
          CenterLoader.show(context);
          final res = await loginFormBloc!.appleSignIn();
          redirectUser(res);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/icon/apple.png',
            height: 25,
          ),
          const SizedBox(width: 7),
          Text(
            'login.lbl_login_by_apple',
            style: TextStyle(color: blackColor, fontSize: pageIconSize),
          ).tr()
        ]),
      ));
}
