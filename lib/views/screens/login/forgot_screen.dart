import 'dart:io';
import 'package:flutter/services.dart';
import '../../../config/icons.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../views/components/center_loader.dart';
import '../../../views/components/root_redirect.dart';
import '../../../bloc/login_form/forgot_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  ForgotFormBloc? forgotFormBloc;

  @override
  initState() {
    super.initState();
    forgotFormBloc = BlocProvider.of<ForgotFormBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          //  backgroundColor: lightColor,
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
          body: Container(
            color: lightColor,
            padding: const EdgeInsets.all(10.0),
            child: FormBlocListener<ForgotFormBloc, String, String>(
              onSubmitting: (context, state) {
                if (state.isValid() == true) {
                  CenterLoader.show(context);
                }
              },
              onSuccess: (context, state) {
                CenterLoader.hide(context);
                forgotFormBloc!.clear();
                RootRedirect.successMsg(
                    context,
                    'settings.verification_email_send_successfully'.tr(),
                    '/login');
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
              child: Column(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'forgotPassword.lbl_forgot_password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: blackColor,
                          ),
                        ).tr(),
                      ]),
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'forgotPassword.lbl_forgot_password_keywords',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: blackColor,
                            ),
                          ).tr(),
                          const SizedBox(height: 20),
                          TextFieldBlocBuilder(
                            textFieldBloc: forgotFormBloc!.email,
                            keyboardType: TextInputType.emailAddress,
                            textStyle: const TextStyle(
                              color: blackColor,
                            ),
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
                                lockIcon,
                                color: blackColorLight,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: primaryColor,
                            ),
                            onPressed: forgotFormBloc!.submit,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                          'forgotPassword.lbl_forgot_password_send',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: lightColor,
                                              fontWeight: FontWeight.bold))
                                      .tr(),
                                ]),
                          ),
                          const SizedBox(height: 11),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
