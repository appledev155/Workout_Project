import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import '../../../config/app_colors.dart';
import '../../../bloc/setting/change_password_form_bloc.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../views/components/center_loader.dart';
import '../../../views/components/root_redirect.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ChangePasswordScreen> {
  ChangePasswordFormBloc? changePasswordFormBloc;

  @override
  void initState() {
    super.initState();
    changePasswordFormBloc = BlocProvider.of<ChangePasswordFormBloc>(context);
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'settings.lbl_change_password'.tr());
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
          backgroundColor: lightColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: lightColor,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 1,
            iconTheme: const IconThemeData(color: blackColor),
            leading: ModalRoute.of(context)?.canPop == true
                ? IconButton(
                    icon: Icon(
                      (context.locale.toString() == "en_US")
                          ? (Platform.isIOS)
                              ? iosBackButton
                              : backArrow
                          : (context.locale.toString() == "ar_AR")
                              ? (Platform.isIOS)
                                  ? iosForwardButton
                                  : forwardArrow
                              : iosForwardButton,
                      color: blackColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
            title: const Text('settings.lbl_change_password',
                    style: TextStyle(color: blackColor))
                .tr(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FormBlocListener<ChangePasswordFormBloc, String, String>(
              onSubmitting: (context, state) {
                // CenterLoader.show(context);
              },
              onSuccess: (context, state) {
                CenterLoader.hide(context);
                RootRedirect.successMsg(
                    context, state.successResponse!.tr(), 'pop');
              },
              onFailure: (context, state) {
                CenterLoader.hide(context);
                /* ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.failureResponse))); */
                Fluttertoast.showToast(
                    msg: state.failureResponse.toString(),
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 5);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: changePasswordFormBloc!.currentPassword,
                      suffixButton: SuffixButton.obscureText,
                      keyboardType: TextInputType.text,
                      textStyle: const TextStyle(
                        color: blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'register.lbl_current_password'.tr(),
                        hintStyle: const TextStyle(
                          color: greyColor,
                        ),
                        prefixIcon: const Icon(lockIcon),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: changePasswordFormBloc!.password,
                      suffixButton: SuffixButton.obscureText,
                      keyboardType: TextInputType.text,
                      textStyle: const TextStyle(
                        color: blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'register.lbl_password'.tr(),
                        hintStyle: const TextStyle(
                          color: greyColor,
                        ),
                        prefixIcon: const Icon(lockIcon),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: changePasswordFormBloc!.confirmPassword,
                      suffixButton: SuffixButton.obscureText,
                      textStyle: const TextStyle(
                        color: blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'register.lbl_confirm_password'.tr(),
                        hintStyle: const TextStyle(
                          color: greyColor,
                        ),
                        prefixIcon: const Icon(lockIcon),
                      ),
                    ),
                    const SizedBox(height: 11),
                    Container(
                        width: deviceWidth,
                        height: unitWidth * 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: primaryDark),
                          onPressed: changePasswordFormBloc!.submit,
                          child: Text(
                            'settings.lbl_update_password',
                            style: TextStyle(
                                fontSize: pageTextSize, color: lightColor),
                          ).tr(),
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  dispose() {
    super.dispose();
    changePasswordFormBloc!.close();
  }
}
