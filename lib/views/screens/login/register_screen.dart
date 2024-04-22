import 'dart:io';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/views/components/custom_web_view_screen.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../bloc/current_user_bloc/current_user_bloc.dart';
import '../../../bloc/login_form/register_form_bloc.dart';
import '../../../config/icons.dart';
import '../../../config/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../../views/components/center_loader.dart';
import '../../../views/components/root_redirect.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterFormBloc? registerFormBloc;
  dynamic tempData;
  final privacyPolicyLink = dotenv.env['PRIVACYPOLICYLINK'];
  final termsConditionsLink = dotenv.env['TERMSCONDITIONSLINK'];
  void initState() {
    super.initState();
    registerFormBloc = BlocProvider.of<RegisterFormBloc>(context);
    getData();
  }

  getData() async {
    tempData = await Notify().getArguments();
    setState(() {});
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'register.lbl_register'.tr());
  }

  clearLoginUserData() async {
    await app_instance.isarServices.cleanDb();
    if (!mounted) return;
    context.read<CurrentUserBloc>().add(const LogOutRequest());
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: lightColor,
            child: Column(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'register.lbl_register',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                      ).tr(),
                    ]),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormBlocListener<RegisterFormBloc, String, String>(
                    onSubmitting: (context, state) {
                      if (state.isValid() == true) {
                        CenterLoader.show(context);
                      }
                    },
                    onSuccess: (context, state) async {
                      if (state.successResponse != '') {
                        CenterLoader.hide(context);
                        registerFormBloc!.clear();
                        clearLoginUserData();
                        RootRedirect.successMsg(
                            context, 'register.success_msg'.tr(), 'clearBack');
                      }
                    },
                    onFailure: (context, state) {
                      CenterLoader.hide(context);
                      /* ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.failureResponse))); */
                      Fluttertoast.showToast(
                          msg: state.failureResponse!,
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 5);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Column(
                        children: <Widget>[
                          TextFieldBlocBuilder(
                            textFieldBloc: registerFormBloc!.name,
                            keyboardType: TextInputType.text,
                            textStyle: const TextStyle(
                              color: blackColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(right: 20.0),
                              filled: true,
                              fillColor: greyColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: 'register.lbl_name'.tr(),
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                color: blackColorLight,
                              ),
                              prefixIcon: const Icon(
                                personIcon,
                                color: blackColorLight,
                              ),
                            ),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: registerFormBloc!.email,
                            keyboardType: TextInputType.emailAddress,
                            // ignore: deprecated_member_use
                            textStyle: const TextStyle(
                              color: blackColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(right: 20.0),
                              filled: true,
                              fillColor: greyColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: 'register.lbl_email'.tr(),
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
                          TextFieldBlocBuilder(
                            textFieldBloc: registerFormBloc!.password,
                            suffixButton: SuffixButton.obscureText,
                            // ignore: deprecated_member_use
                            style: const TextStyle(
                              color: blackColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(right: 20.0),
                              filled: true,
                              fillColor: greyColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: 'register.lbl_password'.tr(),
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
                          TextFieldBlocBuilder(
                            textFieldBloc: registerFormBloc!.confirmPassword,
                            suffixButton: SuffixButton.obscureText,
                            textStyle: const TextStyle(
                              color: blackColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(right: 20.0),
                              filled: true,
                              fillColor: greyColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: 'register.lbl_confirm_password'.tr(),
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
                          const SizedBox(height: 13),
                          const Text('register.lbl_all_required').tr(),
                          const SizedBox(height: 20),
                          /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('register.lbl_agree').tr(),
                                SizedBox(width: 2),
                                Text('appName.ANYTIME WORKOUT', style: TextStyle(fontSize: 16))
                                    .tr(),
                              ]),
                          TextButton(
                            style: TextButton.styleFrom(backgroundColor: lightColor),
                            child: Text('register.lbl_terms_cond',
                                    style: TextStyle(fontSize: 16, color: primaryColor))
                                .tr(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TermScreen(),
                                ),
                              );
                            },
                          ), */
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: RichText(
                                textAlign: TextAlign.center,
                                strutStyle: const StrutStyle(height: 1.5),
                                text: TextSpan(
                                    text: '${'app.lbl_by_using'.tr()} ',
                                    style: TextStyle(
                                      color: blackColor,
                                      fontFamily: 'DM Sans',
                                      fontSize: pageTextSize,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: '${'appName.app_title'.tr()} ',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: pageTextSize,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'DM Sans')),
                                      TextSpan(
                                          text: '${'app.lbl_you_agree'.tr()} '),
                                      TextSpan(
                                          text: 'app.lbl_terms_of_use'.tr(),
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: pageTextSize,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'DM Sans'),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomWebViewScreen(
                                                      title:
                                                          'app.lbl_terms_of_use'
                                                              .tr(),
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
                                          color: blackColor,
                                          fontFamily: 'DM Sans',
                                          fontSize: pageTextSize,
                                        ),
                                      ),
                                      TextSpan(
                                          text: 'app.lbl_privacy_policy'.tr(),
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: pageTextSize,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'DM Sans'),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomWebViewScreen(
                                                      title:
                                                          'app.lbl_privacy_policy'
                                                              .tr(),
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
                          SizedBox(height: 20 * unitHeight),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: primaryColor),
                            onPressed: registerFormBloc!.submit,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'register.lbl_create_account',
                                    style: TextStyle(
                                        color: lightColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ).tr(),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
