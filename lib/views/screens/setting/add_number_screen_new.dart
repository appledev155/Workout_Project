import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/bloc/setting/bloc/add_form_bloc.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;

import '../../../config/app_colors.dart';
import '../../components/center_loader.dart';
import '../../components/check_login.dart';
import '../../components/notify.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class AddNumberScreenNew extends StatefulWidget {
  const AddNumberScreenNew({super.key});

  @override
  State<AddNumberScreenNew> createState() => _AddNumberScreenNewState();
}

class _AddNumberScreenNewState extends State<AddNumberScreenNew> {
  bool? isLogin = false;
  String? maskData = '555555';
  TextEditingController? textEditingController = TextEditingController();
  dynamic focusScope = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? number;
  String dropDownValue = '050';
  dynamic errorString = "";
  int nextButtonCount = 0;

  @override
  void initState() {
    super.initState();
    errorString = "";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/verfied_numbers');
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: lightColor,
          // bottomNavigationBar:
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: blackColor),
            backgroundColor: primaryColor,
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
                    "settings.btn_logout",
                    style: TextStyle(
                        color: lightColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600),
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
                          : (context.locale.toString() == "ar_AR")
                              ? (Platform.isIOS)
                                  ? iosForwardButton
                                  : forwardArrow
                              : iosForwardButton,
                      color: blackColor,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/verfied_numbers'))
                : null,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: Container(
            color: greyColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
              child: BlocListener<AddFormBlocNew, AddFormState>(
                  listener: (context, state) {
                    if (state.status == Status.success) {
                      CenterLoader.hide(context);
                      Navigator.pushNamed(context, '/verify_new_number');
                    }
                    if (state.status == Status.failure) {
                      CenterLoader.hide(context);
                      Fluttertoast.showToast(
                        msg: state.message.toString(),
                        toastLength:
                            Toast.LENGTH_LONG, /* timeInSecForIosWeb: 5 */
                      );
                    }
                  },
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'settings.lbl_verify_your_phone_number',
                                style: TextStyle(
                                    fontSize: 25.sp, fontWeight: FontWeight.w600),
                              ).tr(),
                            ),
                            ListTile(
                              title: Text(
                                'settings.lbl_send_otp_below_number',
                                style: TextStyle(
                                    fontSize: 17.sp, fontWeight: FontWeight.w500),
                              ).tr(),
                            ),
                            ListTile(
                              title: Text(
                                'settings.lbl_phone_number',
                                style: TextStyle(
                                    fontSize: 17.sp, fontWeight: FontWeight.w500),
                              ).tr(),
                            ),
                            // for input box main container
          
                            Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: Container(
                                padding: const EdgeInsets.only(left: 4, right: 4),
                                decoration: BoxDecoration(
                                  color: lightColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    border: Border.all(
                                        color: greyColor.withOpacity(0.9),
                                        width: 0.3)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/uae.png",
                                      height: 35,
                                    ),
                                    const SizedBox(width: 2),
                                    const Text(
                                      '+971',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    verticalInputBoxDevider(),
                                    operatorCodeDropDown(),
                                    verticalInputBoxDevider(),
                                    phoneNumber(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ((errorString == "Phone Number is required." ||
                                        errorString ==
                                            "رقم الهاتف المتحرك مطلوب") &&
                                    nextButtonCount > 0)
                                ? SizedBox(
                                    height: 20,
                                    child: Text(errorString,
                                        style: const TextStyle(
                                            color: favoriteColor)),
                                  )
                                : const SizedBox.shrink(),
          
                            (errorString != null)
                                ? (errorString == "Phone Number is required." ||
                                        errorString == "رقم الهاتف المتحرك مطلوب")
                                    ? const SizedBox(height: 20)
                                    : SizedBox(
                                        height: 20,
                                        child: Text(errorString,
                                            style: const TextStyle(
                                                color: favoriteColor)),
                                      )
                                : const SizedBox(height: 20),
                            const SizedBox(height: 30),
                            nextButton()
                          ],
                        ),
                      ))),
            ),
          )),
    );
  }

  // Next Button
  nextButton() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
            height: unitWidth * 40,
            width: deviceWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () async {
                // call Api when next button click
                await app_instance.storage.write(key: "authyId", value: "0");
                final tempData = await Notify().getArguments();
                String phoneNumber = textEditingController!.text;
                setState(() {
                  nextButtonCount++;
                });
                if (formKey.currentState!.validate()) {
                  context.read<AddFormBlocNew>().add(const Submit());
                  textEditingController!.selection = const TextSelection(
                    baseOffset: 0,
                    extentOffset: 0,
                  );
                }

                // addNumberFormBloc!.submit;
              },
              child: Text(
                'settings.btn_next',
                style: TextStyle(
                  color: lightColor,
                  fontSize: buttonTextSized,
                ),
              ).tr(),
            )));
  }

  Future<bool> _signOut() async {
    CenterLoader.show(context);
    context.read<ChannelBloc>().add(ChannelResetState());
    await app_instance.isarServices.cleanDb();
    await CheckLogin().deleteStore();
    await app_instance.utility.getAlgolia();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return false;

    context.read<CurrentUserBloc>().add(const IsAuthorized(UserModel.empty));
    context.read<CurrentUserBloc>().add(const LogOutRequest());
    print(
        "NumberOfChannel logout ${context.read<ChannelBloc>().state.channelList.length}");

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return false;
    CenterLoader.hide(context);
    if (mounted) {
      Navigator.popAndPushNamed(
        context,
        '/search_result',
      );
    }
    isLogin = false;
    setState(() {});
    return isLogin!;
  }

  _isNumberArabic(String value, BuildContext context) async {
    final tempData = await Notify().getArguments();
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
    if ((value.length > 5 && tempData['MASKNUMBER'] == value.substring(0, 6)) ==
        false) {
      context
          .read<AddFormBlocNew>()
          .add(PhoneNumberChanged(phoneNumber: dropDownValue + value));
    } else {
      context
          .read<AddFormBlocNew>()
          .add(PhoneNumberChanged(phoneNumber: value));
    }
    return value;
  }

  _isValidPhoneNumber(String value, BuildContext context) async {
    final tempData = await Notify().getArguments();
    final _phoneRegex = RegExp('^[0-9\u0660-\u0669]');
    bool flag = false;
    final error =
        (value.isEmpty) ? 'register.err_phoneNumber_required'.tr() : null;

    if ((value.length > 5 && tempData['MASKNUMBER'] == value.substring(0, 6)) ==
        false) {
      context
          .read<AddFormBlocNew>()
          .add(PhoneNumberChanged(phoneNumber: dropDownValue + value));
    } else {
      context
          .read<AddFormBlocNew>()
          .add(PhoneNumberChanged(phoneNumber: value));
    }

    _isNumberArabic(value, context);
    dynamic response = (error != null)
        ? error
        : (value.length > 5 && tempData['MASKNUMBER'] == value.substring(0, 6))
            ? null
            : ((value.length != 7) ||
                    (value.contains('.')) ||
                    (value.contains(',')))
                ? 'settings.valid_phone_number'.tr()
                : _phoneRegex.hasMatch(value)
                    ? null
                    : 'settings.err_phoneNumber_numeric'.tr();

    if ((value.length > 5 && tempData['MASKNUMBER'] == value.substring(0, 6)) ==
            false &&
        response == null) {
      dynamic storedUserPhoneNumber =
          await app_instance.storage.read(key: 'UserPhoneNumbers');
      if (storedUserPhoneNumber != null) {
        dynamic phoneList = json.decode(storedUserPhoneNumber);

        await phoneList.forEach((e) {
          if (e['phoneNumber'] == value) {
            flag = true;
            response = 'settings.phone_already_verified'.tr();
          }
        });
      }
    }
    setState(() {
      errorString = response;
    });
    return response;
  }

  // vertical devider
  verticalInputBoxDevider() {
    return SizedBox(
        height: 40, child: VerticalDivider(color: dividerColor.withOpacity(0.9)));
  }

  // DropDown widget
  operatorCodeDropDown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            dropdownColor: lightColor,
            value: dropDownValue,
            items: <String>['050', '052', '054', '055', '056', '058']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 15),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropDownValue = newValue!;
              });
            }));
  }

  phoneNumber() {
    return BlocBuilder<AddFormBlocNew, AddFormState>(
      builder: (context, blocState) {
        return FutureBuilder(
            future: _isValidPhoneNumber(textEditingController!.text, context),
            builder: (context, AsyncSnapshot snapshot) {
              return Expanded(
                child: TextFormField(
                  showCursor: true,
                  focusNode: focusScope,
                  autofocus: true,
                  controller: textEditingController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  style: const TextStyle(
                    fontSize: 17,
                    color: blackColor,
                    backgroundColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,

                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (snapshot.data != null) {
                      return snapshot.data;
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    context
                        .read<AddFormBlocNew>()
                        .add(PhoneNumberChanged(phoneNumber: value));
                  },
                  decoration: InputDecoration(
                    // helperText: "settings.phone_placeholder".tr(),
                    helperStyle: const TextStyle(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    errorMaxLines: 1,
                    errorText: '',
                    errorStyle: const TextStyle(
                      color: Colors.transparent,
                      fontSize: 0,
                    ),

                    filled: true,
                    fillColor: lightColor,
                    hintText: 'settings.lbl_phone_number'.tr(),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,

                    hintStyle: TextStyle(
                        color: blackColor.withOpacity(0.5),
                        fontSize: 17,
                        fontFamily: 'Mulish'),
                  ),
                  // textFieldBloc: profileFormBloc!.phoneNumber,
                ),
              );
            });
      },
    );
  }
}
