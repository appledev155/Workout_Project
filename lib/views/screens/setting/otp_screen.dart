import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:anytimeworkout/bloc/setting/verification_form_bloc.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/views/components/forms/custom_text_button.dart';
import 'package:anytimeworkout/views/screens/setting/error_info_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../../bloc/contact_form/contact_form_bloc.dart';
import '../../../config/constant.dart';
import '../../../config/styles.dart';
import '../../../views/components/center_loader.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import '../../../config/app_colors.dart';
import '../../../bloc/setting/otp_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int secondsRemaining = Constants().secondsRemaining;
  bool enableResend = false;
  Timer? timer;
  String validate = ' ';
  String currentNumber = '';
  String onlyNumber = "";
  bool flag = false;
  bool isPhoneVerified = false;
  bool enableCallingMessage = false;
  bool showCallButtonWidget = true;
  late Timer automaticCallCancelTimer;
  OtpFormBloc? otpFormBloc = OtpFormBloc();
  bool showTerminateVerificationProcessMessage = false;
  dynamic getTryOtpCount;
  int resendButtonCount = 0;
  TextEditingController otpController = TextEditingController();
  List<String> terminateRequestErrorsList = [
    "A wrong code was provided too many times. Workflow terminated",
    "Max check attempts reached"
  ];

  @override
  void initState() {
    super.initState();
    _getPhoneVerified();
    timerButton();
    otpFormBloc = BlocProvider.of<OtpFormBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNumber();
    });
  }

  getNumber() async {
    currentNumber =
        (await app_instance.storage.read(key: 'newPhoneNumberString'))!;
    onlyNumber = (await app_instance.storage.read(key: 'onlyPhoneNumber'))!;
    if (mounted) {
      setState(() {});
    }
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'settings.lbl_update_phone'.tr());
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  timerButton() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        if (mounted) {
          setState(() {
            secondsRemaining--;
          });
        }
      } else {
        timer!.cancel();
        if (mounted) {
          setState(() {
            enableResend = true;
          });
        }
      }
    });
  }

  Future<bool> _getPhoneVerified() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    isPhoneVerified =
        (currentUser.phoneVerified.toString() == '1') ? true : false;
    if (mounted) {
      setState(() {
        isPhoneVerified = isPhoneVerified;
      });
    }
    return isPhoneVerified;
  }

  @override
  Widget build(BuildContext context) {
    if (resendButtonCount == 2) {
      automaticCallCancelTimer =
          Timer(Duration(seconds: Constants().automaticCallSeconds), () {
        if (resendButtonCount == 2) {
          otpFormBloc!.cancelVerificationProcess();
        }
        if (mounted) {
          setState(() {
            showTerminateVerificationProcessMessage = true;
          });
        }
        if (resendButtonCount == 2) {
          terminateRequest();
        }
      });
    } else if (resendButtonCount == 3) {
      automaticCallCancelTimer.cancel();
    }

    if (resendButtonCount == 3 && enableResend == true) {
      maxReached();
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: lightColor,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            backgroundColor: lightColor,
            elevation: 1,
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
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/verfied_numbers', (route) => false)
                    // Navigator.of(context).pop(),
                    )
                : null,
            title: const Text('settings.lbl_update_phone',
                    style: TextStyle(color: blackColor))
                .tr(),
            iconTheme: const IconThemeData(color: blackColor),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBlocListener<OtpFormBloc, String, String>(
              onSuccess: (context, state) {
                if (state.successResponse == 'settings.phone_success_msg') {
                  var data = 'settings.phone_success_msg'.tr();
                  CenterLoader.hide(context);
                  Fluttertoast.showToast(
                      msg: data,
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 5,
                      backgroundColor: activeColor,
                      textColor: lightColor);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/verfied_numbers', (Route<dynamic> route) => false);
                  // Navigator.pop(context);
                }
              },
              onFailure: (context, state) {
                validate = (state.failureResponse!.isNotEmpty ||
                        state.failureResponse != null)
                    ? "settings.error_invalid_otp".tr()
                    : state.failureResponse!;
                otpController.clear();
                CenterLoader.hide(context);
                flag = true;
                if (terminateRequestErrorsList
                    .contains(state.failureResponse.toString())) {
                  terminateRequest();
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /* ChangeNumber(
                      currentNumber: currentNumber,
                      hintText: 'settings.otp_msg_send'.tr(),
                    ), */
                    // show terminate verification process
                    (resendButtonCount == 3 && enableCallingMessage == false)
                        ? showCallingMessage()
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      (resendButtonCount == 3 ||
                              (resendButtonCount == 2 && enableResend == true))
                          ? Text("settings.otp_msg_call",
                                  style: TextStyle(
                                      color: primaryDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: pageTitleSize))
                              .tr()
                          : Text('settings.otp_msg_send',
                                  style: TextStyle(
                                      color: primaryDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: pageTitleSize))
                              .tr(),
                      const SizedBox(width: 4),
                      Text(currentNumber,
                          textDirection: ui.TextDirection.ltr,
                          style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.w500,
                              fontSize: pageTitleSize))
                    ]),
                    _buildChangeNumberButton(),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(height: 40),
                    Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: PinPut(
                          autofocus: true,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          fieldsAlignment: MainAxisAlignment.spaceAround,
                          fieldsCount: 4,
                          selectedFieldDecoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(10)),
                          submittedFieldDecoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          followingFieldDecoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          onSubmit: (String pin) {
                            otpFormBloc!.otpCode.updateValue(pin);
                          },
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                validate = "";
                              });
                            }
                          },
                        )),
                    if (flag) ...[
                      const SizedBox(height: 20),
                      Text(validate,
                          style: const TextStyle(
                              color: favoriteColor, fontSize: 15)),
                    ],
                    const SizedBox(height: 20),
                    _buildSendButton(),
                    (enableResend == true)
                        ? _buildResendButton()
                        : (resendButtonCount >= 3)
                            ? const SizedBox.shrink()
                            : Container(
                                width: deviceWidth,
                                padding: EdgeInsets.symmetric(
                                    horizontal: pageHPadding),
                                child: CustomTextButton(
                                  title: 'settings.btn_otp_resend'.tr(),
                                  titleSize: pageTextSize,
                                  titleColor:
                                      enableResend ? primaryColor : greyColor,
                                  buttonColor: lightColor,
                                  borderColor: lightColor.withOpacity(0),
                                  onPressed: () {},
                                  radius: unitWidth * 4,
                                )),
                    const SizedBox(
                      height: 10,
                    ),
                    if (secondsRemaining != 0) showSecondRemainingTimer()
                  ],
                ),
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  onOptionSubmit(BuildContext context, String opt) async {
    dynamic getTryOtpCount =
        await app_instance.storage.read(key: "tryOtpCount");
    dynamic tryOtpCountIncrease = int.parse(getTryOtpCount.toString()) + 1;
    await app_instance.storage
        .write(key: "tryOtpCount", value: tryOtpCountIncrease.toString());
    VerificationScreenBloc verficationScreenBloc = VerificationScreenBloc();
    verficationScreenBloc.optField.updateValue(opt);
    verficationScreenBloc.submit();
  }

  // function for terminate request
  Future<dynamic> terminateRequest() async {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<ContactFormBloc>(
            create: (context) => ContactFormBloc(),
            child: const ErrorInfoScreen(errorType: "terminateRequest"),
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  // function for max reached attempts
  maxReached() {
    if (context.mounted) {
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<ContactFormBloc>(
              create: (context) => ContactFormBloc(),
              child: const ErrorInfoScreen(errorType: "maxAttempts"),
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  // show message when call from vonage
  Widget showCallingMessage() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: lightBlueColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          "${"settings.call_msg".tr()} $currentNumber",
          style: TextStyle(fontSize: pageTitleSize),
        ));
  }

  // call button widget
  Widget callButtonWidget() {
    return TextButton.icon(
      label: const Text('settings.lbl_call').tr(),
      icon: const Icon(
        Icons.phone,
        size: 24.0,
      ),
      onPressed: () async {
        setState(() {
          showCallButtonWidget = false;
        });
        automaticCallCancelTimer.cancel();
        await app_instance.userRepository.storeOtpCountInDb(onlyNumber);
        if (enableResend == true &&
            showTerminateVerificationProcessMessage == false) {
          if (mounted) {
            setState(() {
              secondsRemaining = Constants().secondsRemaining;
              enableResend = false;
              timerButton();
              resendButtonCount = resendButtonCount + 1;
              validate = "";
            });
          }
          otpFormBloc!.resend();
        }
        if (showTerminateVerificationProcessMessage == true) {
          if (mounted) {
            setState(() {
              showTerminateVerificationProcessMessage = false;
            });
          }
        }
      },
    );
  }

  showSecondRemainingTimer() {
    if (resendButtonCount >= 3) {
      return Text(
        '${'settings.message_terminate_timer'.tr()} ${_printDuration(Duration(seconds: secondsRemaining))}',
        style: const TextStyle(color: blackColor, fontSize: 15),
      );
    } else {
      return Text(
        '${'settings.otp_resend_msg'.tr()} ${_printDuration(Duration(seconds: secondsRemaining))}',
        style: const TextStyle(color: blackColor, fontSize: 15),
      );
    }
  }

  Widget _buildResendButton() {
    return (int.parse(resendButtonCount.toString()) <= 1)
        ? Container(
            width: deviceWidth / 1.8,
            margin: const EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: pageHPadding),
            child: CustomTextButton(
              title: 'settings.btn_otp_resend'.tr(),
              titleSize: pageTextSize,
              titleColor: enableResend ? primaryColor : greyColor,
              buttonColor: lightColor,
              borderColor: primaryColor.withOpacity(0.3),
              onPressed: () async {
                if (enableResend == true) {
                  if (int.parse(resendButtonCount.toString()) < 3) {
                    if (mounted) {
                      setState(() {
                        secondsRemaining = Constants().secondsRemaining;
                        enableResend = false;
                        timerButton();
                        resendButtonCount = resendButtonCount + 1;
                        validate = "";
                      });
                    }
                    await app_instance.userRepository
                        .storeOtpCountInDb(onlyNumber);
                    dynamic authyId =
                        await app_instance.storage.read(key: "authyId");
                    if (authyId == '132') {
                      if (context.mounted) {
                        onOptionSubmit(context, '2');
                      }
                    }
                  } else {
                    return null;
                  }
                } else {
                  return null;
                }
              },
              radius: unitWidth * 4,
            ))
        : (int.parse(resendButtonCount.toString()) == 2 &&
                showCallButtonWidget == true)
            ? callButtonWidget()
            : const SizedBox.shrink();
  }

  // Confirm button
  Widget _buildSendButton() {
    return Container(
        width: deviceWidth,
        height: 40 * unitWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: CustomTextButton(
          title: 'settings.btn_confirm'.tr(),
          titleSize: pageTextSize,
          titleColor: lightColor,
          buttonColor: activeColor.withOpacity(0.8),
          borderColor: activeColor.withOpacity(0.8),
          onPressed: () async {
            dynamic requestId =
                await app_instance.storage.read(key: "nexmoRequestId");
            dynamic twillioResponseJsonData =
                await app_instance.storage.read(key: "twillioResponseJsonData");
            if (otpController.text.length == 4) {
              if (resendButtonCount == 3) {
                enableCallingMessage = true;
              }
              otpFormBloc!.submit();
              CenterLoader.show(context);
              await app_instance.userRepository.storeOTP(
                  onlyNumber,
                  otpController.text.toString(),
                  (requestId == null) ? "" : requestId,
                  twillioResponseJsonData);
            }
          },
          radius: unitWidth * 4,
        ));
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
