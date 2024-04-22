import 'dart:io';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/views/components/forms/custom_text_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../bloc/setting/verified_number_form_bloc.dart';
import '../../../views/components/center_loader.dart';
import '../../../views/components/root_redirect.dart';
import 'dart:convert';
import 'package:anytimeworkout/config.dart' as app_instance;

class PhoneValue {
  final String _key;
  final String _value;
  PhoneValue(this._key, this._value);
}

class VerifedNumberScreen extends StatefulWidget {
  const VerifedNumberScreen({Key? key}) : super(key: key);
  @override
  _VerifedNumberScreenState createState() => _VerifedNumberScreenState();
}

class _VerifedNumberScreenState extends State<VerifedNumberScreen> {
  String _currentPhoneValue = '';
  String _prevPhoneValue = '';
  final _buttonOptions = [];

  @override
  void initState() {
    super.initState();
    _getActivePhoneNumber();
    _getUserPhoneNumber();
  }

  Future<String> _getActivePhoneNumber() async {
    final data = await app_instance.storage.read(key: 'JWTUser');
    dynamic rec = json.decode(data.toString());
    if (rec.containsKey('phoneNumber') && rec['phoneNumber'] != null) {
      setState(() {
        _currentPhoneValue = rec['phoneNumber'];
      });
    }
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'settings.lbl_verified_numbers'.tr());
    return _currentPhoneValue;
  }

  Future<dynamic> _getUserPhoneNumber() async {
    dynamic data = await app_instance.storage.read(key: 'UserPhoneNumbers');
    if (data != null) {
      dynamic recList = json.decode(data);
      recList.forEach((e) {
        this._buttonOptions.add(PhoneValue(e['phoneNumber'], e['phoneNumber']));
      });
      setState(() {});
    }
    return _buttonOptions;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("settings.btn_cancel").tr(),
      onPressed: () {
        setState(() {
          _currentPhoneValue = _prevPhoneValue;
        });
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("settings.save").tr(),
      onPressed: () {
        Navigator.of(context).pop();
        context
            .read<VerifiedNumberFormBloc>()
            .phoneID
            .updateValue(_currentPhoneValue.toString());
        context.read<VerifiedNumberFormBloc>().submit();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('settings.lbl_verified_numbers').tr(),
      content: Row(
        children: [
          Flexible(
              child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                      text: 'settings.are_you_sure_active_this_number'.tr(),
                      style: const TextStyle(color: blackColor, fontSize: 16),
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(text: _currentPhoneValue.toString()),
                        const TextSpan(text: ' ? '),
                      ])))
          /* Text("settings.are_you_sure_active_this_number", maxLines: 2,).tr(),
          SizedBox(width: 3),
          Text(_currentPhoneValue.toString()),
          Text("?"), */
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return BlocProvider(
      create: (context) => VerifiedNumberFormBloc(),
      child: Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pushNamed(context, '/setting');
              return shouldPop;
            },
            child: Scaffold(
              
                resizeToAvoidBottomInset: false,
                backgroundColor: greyColor,
                appBar: AppBar(
                    centerTitle: true,
                    title: const Text(
                      'settings.lbl_verified_numbers',
                      style: TextStyle(color: blackColor),
                    ).tr(),
                    backgroundColor: primaryColor,
                    elevation: 1,
                    leading: IconButton(
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
                        onPressed: () =>
                            Navigator.pushNamed(context, '/setting')
                        // Navigator.of(context).pop(),
                        ),
                    iconTheme: const IconThemeData(color: blackColor),
                    systemOverlayStyle: SystemUiOverlayStyle.dark),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                      FormBlocListener<VerifiedNumberFormBloc, String, String>(
                    onSubmitting: (context, state) {
                      CenterLoader.show(context);
                    },
                    onSuccess: (context, state) {
                      CenterLoader.hide(context);
                      RootRedirect.successMsg(
                          context, state.successResponse!.tr(), '');
                    },
                    onFailure: (context, state) {
                      CenterLoader.hide(context);
                      /* ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.failureResponse))); */
                      Fluttertoast.showToast(
                          backgroundColor: primaryDark,
                          msg: state.failureResponse.toString(),
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 5);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'settings.note_verified_number',
                              style: TextStyle(
                                fontSize: pageIconSize,
                                color: blackColor
                              ),
                            ).tr(),
                          ),
                          ..._buttonOptions
                              .map((phoneValue) => RadioListTile<String>(
                                    activeColor: primaryDark,
                                    groupValue: _currentPhoneValue,
                                    title: Text(
                                      phoneValue._value,
                                      style: TextStyle(fontSize: pageIconSize),
                                    ),
                                    value: phoneValue._key,
                                    onChanged: (val) {
                                      setState(() {
                                        _prevPhoneValue = _currentPhoneValue;
                                        _currentPhoneValue = val.toString();
                                      });
                                      showAlertDialog(context);
                                    },
                                  ))
                              .toList(),
                          SizedBox(height: 20 * unitHeight),
                          _buildVerifiedButton()
                        ],
                      ),
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget _buildVerifiedButton() {
    return Container(
        width: deviceWidth/1.5,
        height: unitWidth * 40,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: CustomTextButton(
          title: 'settings.lbl_Verify_new_number'.tr(),
          titleSize: pageIconSize,
          titleColor: lightColor,
          elevation: 1,
          buttonColor: primaryColor,
          borderColor: lightColor.withOpacity(0),
          onPressed: () => Navigator.pushNamed(context, '/add_new_number'),
          radius: unitWidth * 4,
        ));
  }
}
