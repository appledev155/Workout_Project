import 'dart:async';
import 'dart:io';
import 'package:anytimeworkout/bloc/contact_form/contact_form_bloc.dart';
import 'package:anytimeworkout/config/constant.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/module/chat/pages/components/bottom_loader.dart';
import 'package:anytimeworkout/views/components/forms/custom_text_button.dart';
import 'package:anytimeworkout/views/screens/setting/error_info_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../../views/components/notify.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/setting/verification_form_bloc.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../views/components/center_loader.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

import 'change_number_component.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  PhoneVerificationScreenState createState() => PhoneVerificationScreenState();
}

class PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  String? _twillono;
  //static const platform = const MethodChannel('sendSms');
  String errorMessage = '';
  String currentNumber = '';
  String onlyPhoneNumber = "";
  dynamic url;
  bool showReceiveSmsButton = true;
  VerificationScreenBloc? _verficationScreenBloc;
  String? hideReceiveOTP = 'true';
  StreamSubscription<String>? subscription;
  @override
  initState() {
    super.initState();
    getNumber();
    _verficationScreenBloc = BlocProvider.of<VerificationScreenBloc>(context);
  }

  onOptionSubmit(BuildContext context, String opt) async {
    await app_instance.storage.write(key: "tryOtpCount", value: "0");
    _verficationScreenBloc!.optField.updateValue(opt);
    _verficationScreenBloc!.submit();
  }

  Future<Null> sendSms(String otpCode) async {
    await app_instance.storage.write(key: 'isNewNumber', value: 'true');

    CenterLoader.show(context);
    if (Platform.isIOS)
      url = 'sms:$_twillono&body=$otpCode';
    else
      url = 'sms:$_twillono?body=$otpCode';
    await launch(url);
    await Future<void>.delayed(Duration(seconds: 15));

    if (errorMessage == 'PlatformException(Err, Sms Not Sent, , null)') {
      Fluttertoast.showToast(
          msg: "settings.enable_msg_permission".tr(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5);
    } else {
      bool status = await Notify().checkValidNumber();
      CenterLoader.hide(context);
      Notify().messageNotify(status);
      if (status == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/search_result', (Route<dynamic> route) => false);
      }
    }
  }

  getNumber() async {
    final tempData = await Notify().getArguments();
    _twillono = tempData['TWILLONO'];
    currentNumber =
        (await app_instance.storage.read(key: 'newPhoneNumberString'))!;
    onlyPhoneNumber =
        (await app_instance.storage.read(key: 'onlyPhoneNumber'))!;
    if (mounted) {
      setState(() {});
    }
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'settings.lbl_update_phone'.tr());
  }

  @override
  Widget build(BuildContext context) {
    subscription = Constants.isFailed.stream.listen(
        (data) {
          hideReceiveOTP = data;
        },
        onDone: () {},
        onError: (error) {
          hideReceiveOTP = "false";
        });

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: lightColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          elevation: 1,
          title: const Text(
            'settings.lbl_update_phone',
            style: TextStyle(color: blackColor),
          ).tr(),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_new_number');
                    //  Navigator.pop(context);
                  } /* Navigator.of(context).pop() */,
                )
              : null,
          backgroundColor: lightColor,
          iconTheme: const IconThemeData(color: blackColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FormBlocListener<VerificationScreenBloc, String, dynamic>(
            onSubmitting: (context, state) {
              CenterLoader.show(context);
            },
            onSuccess: (context, state) {
              CenterLoader.hide(context);
              if (state.successResponse == '2') {
                Navigator.pushNamed(context, '/otp_screen');
              } else {
                sendSms(state.successResponse.toString());
              }
            },
            onFailure: (context, state) {
              Constants.isFailed.sink.add("0");
              CenterLoader.hide(context);
              Fluttertoast.showToast(
                  msg: state.failureResponse,
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 5);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                ChangeNumber(
                  currentNumber: currentNumber,
                  hintText: 'settings.verification_msg'.tr(),
                ),
                /*  Text('settings.verification_msg',
                        style: TextStyle(
                            fontSize: pageTitleSize, fontWeight: FontWeight.w600))
                    .tr(),
                const SizedBox(height: 30),
                Text(
                  currentNumber,
                  textDirection: ui.TextDirection.ltr,
                  style: TextStyle(
                      color: primaryDark,
                      fontWeight: FontWeight.w500,
                      fontSize: pageIconSize),
                ),
                const SizedBox(height: 15), */
                /*  Text('settings.select_method',
                        style: TextStyle(fontSize: pageTextSize))
                    .tr(),
               */

                _buildChangeNumberButton(),
                const SizedBox(height: 15),
                /* (hideReceiveOTP == "true")
                    ? Container(
                        height: 40 * unitWidth,
                        width: deviceWidth,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: primaryDark,
                              textStyle: const TextStyle(color: lightColor)),
                          onPressed: () {
                            onOptionSubmit(context, '1');
                          },
                          child: Text(
                            'settings.send_sms',
                            style: TextStyle(
                              fontSize: pageTextSize,
                            ),
                          ).tr(),
                        ))
                    : Container(), */
                //  const SizedBox(height: 15),
                /*  (hideReceiveOTP == "false")
                    ? */
                (showReceiveSmsButton == true)
                    ? receiveSmsButton()
                    : const BottomLoader()
                /*  : Container() */
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Receive SMS button component
  Widget receiveSmsButton() {
    return SizedBox(
      height: 40 * unitWidth,
      width: deviceWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: primaryDark),
              borderRadius: BorderRadius.circular(5)),
          backgroundColor: primaryDark,
        ),
        child: Text(
          'settings.btn_recieve_sms',
          style: TextStyle(
            color: lightColor,
            fontSize: pageTextSize,
          ),
        ).tr(),
        onPressed: () async {
          if (!mounted) return;
          setState(() {
            showReceiveSmsButton = false;
          });
          dynamic otpCount = 0;
          dynamic getOtpCount = await app_instance.userRepository
              .storeOtpCountInDb(onlyPhoneNumber);
          if (getOtpCount.containsKey('otp_count')) {
            await app_instance.storage.write(
                key: "otpCountFromServer",
                value: getOtpCount['otp_count'].toString());
            otpCount = int.parse(getOtpCount['otp_count'].toString());
          }
          if (otpCount < 4) {
            if (mounted) {
              onOptionSubmit(context, '2');
            }
          } else {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<ContactFormBloc>(
                    create: (context) => ContactFormBloc(),
                    child: const ErrorInfoScreen(errorType: "maxAttempts"),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildChangeNumberButton() {
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: CustomTextButton(
          title: 'settings.otp_change_number'.tr(),
          titleSize: pageTextSize,
          titleColor: blackColor,
          buttonColor: lightColor,
          borderColor: lightColor,
          onPressed: () =>
              Navigator.popAndPushNamed(context, '/add_new_number'),
          radius: unitWidth * 4,
        ));
  }
}
