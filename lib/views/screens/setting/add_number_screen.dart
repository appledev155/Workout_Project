import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../bloc/setting/add_number_form_bloc.dart';
import '../../../config/icons.dart';
import 'package:flutter/services.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../views/components/center_loader.dart';
import '../../components/check_login.dart';
import '../../components/notify.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class AddNumberScreen extends StatefulWidget {
  const AddNumberScreen({Key? key}) : super(key: key);

  _AddNumberScreenState createState() => _AddNumberScreenState();
}

class _AddNumberScreenState extends State<AddNumberScreen> {
  AddNumberFormBloc? addNumberFormBloc;
  String? number;
  bool? isLogin = false;
  bool flag = false;
  String? maskData = '555555';
  @override
  void initState() {
    super.initState();
    addNumberFormBloc = BlocProvider.of<AddNumberFormBloc>(context);
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'settings.lbl_update_phone'.tr());
  }

  Future<bool> _signOut() async {
    // TO DO improvement needed
    // final loginBy = await _storage.read(key: 'loginBy');
    CenterLoader.show(context);
    await CheckLogin().deleteStore();

    if (!mounted) return false;
    CenterLoader.hide(context);

    Navigator.of(context).pushNamedAndRemoveUntil(
        '/search_result', (Route<dynamic> route) => false);
    isLogin = false;
    setState(() {});
    return isLogin!;
  }

  @override
  Widget build(BuildContext context) {
    var isCheckKeyboardOpenOrClose = MediaQuery.of(context).viewInsets.bottom;
    var maskFormatter = MaskTextInputFormatter(
        mask: '##-###-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightColor,
      // bottomNavigationBar:
      appBar: AppBar(
        centerTitle: true,
        // title: Text(
        //   'settings.lbl_update_phone',
        //   style: TextStyle(color: blackColor),
        // ).tr(),

        iconTheme: const IconThemeData(color: blackColor),
        backgroundColor: lightColor,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: MaterialButton(
              padding: const EdgeInsets.only(left: 20, right: 20),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: primaryColorLight, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              elevation: 1.0,
              onPressed: _signOut,
              child: Text(
                "settings.lbl_logout",
                style: TextStyle(
                    color: primaryColorLight,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700),
              ).tr(),
            ),
          )
        ],
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: FormBlocListener<AddNumberFormBloc, String, String>(
        onSubmitting: (context, state) {
          // CenterLoader.show(context);
        },
        onSuccess: (context, state) {
          CenterLoader.hide(context);
          Navigator.pushNamed(context, '/verify_new_number');
        },
        onFailure: (context, state) {
          CenterLoader.hide(context);
          Fluttertoast.showToast(
            msg: state.failureResponse.toString(),
            toastLength: Toast.LENGTH_LONG, /* timeInSecForIosWeb: 5 */
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'settings.lbl_verify_your_phone_number',
                  style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600),
                ).tr(),
              ),
              ListTile(
                title: Text(
                  'settings.lbl_send_otp_below_number',
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                ).tr(),
              ),
              ListTile(
                title: Text(
                  'settings.lbl_phone_number',
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                ).tr(),
              ),
              Row(children: [
                Image.asset(
                  "assets/images/uae.png",
                  height: 40,
                ),
                const SizedBox(width: 15),
                const Text(
                  '+971',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFieldBlocBuilder(
                    cursorColor: primaryDark,

                    //  decoration: const InputDecoration(border: OutlineInputBorder()),
                    textFieldBloc: addNumberFormBloc!.phoneNumber,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        number = val.replaceAll(" ", '');
                      });
                    },

                    textStyle: TextStyle(
                      fontSize:
                          (number != null && number!.length >= 10) ? 16 : 17,
                      color: greyColor,
                      backgroundColor: Colors.white,
                    ),

                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 0.0),
                      labelText: "settings.phone_placeholder".tr(),
                      labelStyle:
                          (WidgetsBinding.instance.window.viewInsets.bottom >
                                  0.0)
                              ? Theme.of(context).textTheme.titleLarge
                              : Theme.of(context).textTheme.titleMedium,

                      isCollapsed: true,
                      //  hintText: 'settings.phone_placeholder'.tr(),

                      hintStyle: const TextStyle(
                        color: greyColor,
                      ),

                      // prefixIcon: Icon(
                      //   contactUsIcon,
                      //   color: primaryDark,
                      // ),
                    ),

                    inputFormatters: [
                      (number != null && number!.toString().contains(maskData!))
                          ? FilteringTextInputFormatter.allow(
                              RegExp('[\u0660-\u06690-9]'))
                          : MaskedInputFormatter('## ### ####'),
                    ],
                  ),
                )
              ]),
              const SizedBox(height: 50),
              Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                      height: unitWidth * 40,
                      width: deviceWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () {
                          addNumberFormBloc!.submit;
                        },
                        child: Text(
                          'settings.lbl_next',
                          style: TextStyle(
                            color: lightColor,
                            fontSize: pageTextSize,
                          ),
                        ).tr(),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    addNumberFormBloc!.close();
  }

  Future<String?> _isValidPhoneNumber(String value) async {
    final tempData = await Notify().getArguments();
    final _phoneRegex = RegExp('^[0-9\u0660-\u0669]');
    bool flag = false;
    final error =
        (value.isEmpty) ? 'register.err_phoneNumber_required'.tr() : null;

    _isNumberArabic(value);
    dynamic response = (error != null)
        ? error
        : (value.replaceAll(' ', '').length > 5 &&
                tempData['MASKNUMBER'] ==
                    value.replaceAll(' ', '').substring(0, 6))
            ? null
            : (value.replaceAll(' ', '').length != 10)
                ? 'settings.valid_phone_number'.tr()
                : _phoneRegex.hasMatch(value)
                    ? null
                    : 'settings.err_phoneNumber_numeric'.tr();

    if ((value.replaceAll(' ', '').length > 5 &&
                tempData['MASKNUMBER'] ==
                    value.replaceAll(' ', '').substring(0, 6)) ==
            false &&
        response == null) {
      dynamic storedUserPhoneNumber =
          await app_instance.storage.read(key: 'UserPhoneNumbers');
      if (storedUserPhoneNumber != null) {
        dynamic phoneList = json.decode(storedUserPhoneNumber);

        await phoneList.forEach((e) {
          if (e['phoneNumber'] == value.replaceAll(' ', '')) {
            flag = true;
            response = 'settings.phone_already_verified'.tr();
          }
        });
      }
    }

    return response;
  }

  _isNumberArabic(String value) {
    value = value
        .replaceAll('\u0660', '0')
        .replaceAll('\u0661', '1')
        .replaceAll('\u0662', '2')
        .replaceAll('\u0663', '3')
        .replaceAll('\u0664', '4')
        .replaceAll('\u0665', '5')
        .replaceAll('\u0666', '6')
        .replaceAll('\u0667', '7')
        .replaceAll('\u0668', '8')
        .replaceAll('\u0669', '9');
    addNumberFormBloc!.phoneNumber.updateValue(value);
    return value;
  }
}
