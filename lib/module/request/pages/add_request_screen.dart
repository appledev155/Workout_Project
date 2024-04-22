import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/config/data.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/request/bloc/addRequest/add_request_bloc.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:anytimeworkout/views/components/static_drop_down.dart';
import 'dart:ui' as ui;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../module/request/model/request_model.dart';
import '../../../views/components/center_loader.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import '../../../views/components/forms/input_field.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({Key? key}) : super(key: key);
  @override
  AddRequestScreenState createState() => AddRequestScreenState();
}

class AddRequestScreenState extends State<AddRequestScreen> {
  final ValueNotifier<CountryCode> country =
      ValueNotifier(const FlCountryCodePicker().countryCodes[235]);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddRequestScreenState({this.editId, this.item, this.onRefresh});
  String? editId;
  RequestModel? item;
  Function()? onRefresh;
  String? selectedDropDownValue = 'ALL_CITIES';
  AddRequestBloc? addRequestBloc;
  List<String> selectedButtonsList = ['3'];
  TextEditingController? requestController = TextEditingController();
  TextEditingController? requestBudgetController = TextEditingController();
  TextEditingController? requestCityController = TextEditingController();
  TextEditingController? requestNumberController = TextEditingController();
  TextEditingController? requestContactType = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String phoneNumber = "";
  String countryCode = "971";

  String? formObject = '0';
  String? stdCountryCode;
  int? activateStatus = 0;
  bool? isButtonEnabled1 = false;
  bool? isButtonEnabled2 = true;
  bool? isButtonEnabled3 = false;
  bool? isButtonEnable4 = false;
  int? contact = 3;
  FocusNode? descNode = FocusNode();
  FocusNode? budgetNode = FocusNode();
  FocusNode? numNode = FocusNode();
  FocusNode? phoneNumberNode = FocusNode();

  bool? isWhatsapp = false;
  bool? isCall = false;
  bool? byMessage = false;
  List? selectedValue = [];
  String? city = '';
  String? isFirstRequest = '';
  @override
  void initState() {
    getVerifiedMobileNumber();
    addRequestBloc = BlocProvider.of<AddRequestBloc>(context);
    getRequestValue();
    requestNumberController!.addListener(() {
      var baseOffset = requestNumberController!.value.selection.baseOffset;
      var extentOffset = requestNumberController!.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        requestNumberController!.value =
            requestNumberController!.value.copyWith(
          text: requestNumberController!.text
              .replaceAll('\u0660', '0')
              .replaceAll('\u0661', '1')
              .replaceAll('\u0662', '2')
              .replaceAll('\u0663', '3')
              .replaceAll('\u0664', '4')
              .replaceAll('\u0665', '5')
              .replaceAll('\u0666', '6')
              .replaceAll('\u0667', '7')
              .replaceAll('\u0668', '8')
              .replaceAll('\u0669', '9'),
          selection: TextSelection(
              baseOffset: requestNumberController!.text.length,
              extentOffset: requestNumberController!.text.length),
          composing: TextRange.empty,
        );
      }
    });
    requestBudgetController!.addListener(() {
      var baseOffset = requestBudgetController!.value.selection.baseOffset;
      var extentOffset = requestBudgetController!.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        requestBudgetController!.value =
            requestBudgetController!.value.copyWith(
          text: requestBudgetController!.text
              .replaceAll('\u0660', '0')
              .replaceAll('\u0661', '1')
              .replaceAll('\u0662', '2')
              .replaceAll('\u0663', '3')
              .replaceAll('\u0664', '4')
              .replaceAll('\u0665', '5')
              .replaceAll('\u0666', '6')
              .replaceAll('\u0667', '7')
              .replaceAll('\u0668', '8')
              .replaceAll('\u0669', '9'),
          selection: TextSelection(
              baseOffset: requestBudgetController!.text.length,
              extentOffset: requestBudgetController!.text.length),
          composing: TextRange.empty,
        );
      }
    });
    super.initState();
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'request.lbl_title'.tr());
  }

  getVerifiedMobileNumber() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    dynamic userPhoneNumber =
        await app_instance.storage.read(key: 'UserPhoneNumbers');
    if (currentUser.number != null &&
        currentUser.phoneVerified.toString() == "1") {
      for (var number in jsonDecode(userPhoneNumber)) {
        if (number['phoneNumber'].toString() == currentUser.number.toString()) {
          setState(
            () {
              requestNumberController!.text = currentUser.number.toString();
              dynamic getDialCode = currentUser.number!.substring(0, 3);
              if (dialCodes.contains(getDialCode.toString())) {
                requestNumberController!.text =
                    currentUser.number!.substring(1);
              }
            },
          );
        }
      }
    }
  }

/* 
  setItems() {
    if (widget.item!.descriptionEn != null) {
      requestController!.text = widget.item!.descriptionEn!;
    } else {
      requestController!.text = widget.item!.descriptionAr!;
    }

    requestBudgetController!.text = widget.item!.budget!.replaceAll(',', '');
    selectedDropDownValue = widget.item!.location;
    requestNumberController!.text = widget.item!.phone!.replaceAll('+', '');
    city = widget.item!.location!;

    List<String> splitArray = widget.item!.contactType!.split(",");
    if (splitArray.isNotEmpty) {
      for (var i in splitArray) {
        String trimValue = i.trim();
        selectedButtonsList.add(trimValue);
      }
    }

    if (city != null) {
      formObject =
          (city!.contains('_') ? city.toString().replaceAll('_', ' ') : city);
      app_instance.storage.write(key: 'SelectLocation', value: formObject);
    } else {
      formObject = 'request.lbl_select_city1'.toString().tr();
    }
  } */
  void getRequestValue() async {
    isFirstRequest = await app_instance.storage.read(key: 'is_first_request');
  }

  getParams() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    if (currentUser.token!.isNotEmpty) {
      Object jsonData = {'token': currentUser.token.toString()};
      dynamic resultData =
          await app_instance.userRepository.addPropertyLimitStatus(jsonData);

      if (resultData['request_status'] == true) {
        isButtonEnabled2 = false;
        Fluttertoast.showToast(
            msg:
                '${'request.lbl_request_limit1'.tr()} ${resultData['request_limit']} ${'request.lbl_request_limit2'.tr()}',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5);
        Navigator.pop(context);
      }
      final result = await Notify().getArguments();
      final data = await app_instance.storage.read(key: 'JWTUser');
      dynamic user = jsonDecode(data.toString());
      stdCountryCode = result['STDCODE'].toString().replaceAll('+', '');
      if (user['phoneNumber'].toString().isNotEmpty &&
          user['phoneNumber'] != null) setState(() {});
    }
  }

  onSubmit(activateStatus) async {
    if (requestController!.text.isEmpty) {
      FocusScope.of(context).requestFocus(descNode);
    }
    if (requestNumberController!.text.isEmpty) {
      FocusScope.of(context).requestFocus(numNode);
    }
    dynamic phoneNumber =
        "$countryCode ${requestNumberController!.text.trim()}";

    /*    String? requestID =
        (widget.editId.toString().isNotEmpty) ? widget.editId.toString() : ''; */
    addRequestBloc!.localeLangField.updateValue(context.locale.toString());
    addRequestBloc!.description.updateValue(requestController!.text.trim());
    addRequestBloc!.budget.updateValue(requestBudgetController!.text.trim());
    addRequestBloc!.mobile.updateValue(phoneNumber);
    app_instance.storage.write(
        key: 'selectedContactWay', value: selectedButtonsList.toString());
    app_instance.storage
        .write(key: "requestActivateStatus", value: activateStatus.toString());

    if (activateStatus == 1) {
      context
          .read<ChannelBloc>()
          .add(const NewRequestCreated(selfNewRequest: true));
    }
    addRequestBloc!.submit();
  }

  Widget showLabel(String title) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(fontSize: pageTitleSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/my_requests_screen');
        return shouldPop;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: lightColor,
          appBar: AppBar(
            title: Text(
              'request.lbl_title'.tr(),
              style: const TextStyle(color: blackColor),
            ).tr(),
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/my_requests_screen');
                    })
                : null,
          ),
          body: FormBlocListener<AddRequestBloc, String, String>(
              onSubmitting: (context, state) {
                if (state.isValid() == true) {
                  CenterLoader.show(context);
                }
              },
              onSuccess: (context, state) async {
                CenterLoader.hide(context);
                if (activateStatus == 1) {
                  if (isFirstRequest != null &&
                      isFirstRequest!.isNotEmpty &&
                      isFirstRequest == "1") {
                    Fluttertoast.showToast(
                        msg: 'request.lbl_added_request'.tr(),
                        toastLength: Toast.LENGTH_LONG);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'request.lbl_activated_request'.tr(),
                        toastLength: Toast.LENGTH_LONG);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: 'request.lbl_added_request'.tr(),
                      toastLength: Toast.LENGTH_LONG);
                }
                if (state.successResponse == "success") {
                  Navigator.pushNamed(context, '/my_requests_screen');
                }
              },
              onFailure: (context, state) {
                CenterLoader.hide(context);
                Fluttertoast.showToast(
                    msg: state.failureResponse!,
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 5);
              },
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'request.lbl_text1',
                              style: TextStyle(fontSize: pageTitleSize),
                            ).tr()),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildrequestEditView(),
                        showLabel("addproperty.lbl_price_title".tr()),
                        _buildrequestBudgetEditView(),
                        _buildLocationInput(),
                        SizedBox(
                          height: unitWidth * 17,
                        ),
                        showLabel("request.lbl_text2".tr()),
                        _buildRequestTypeButton(),
                        (selectedButtonsList.contains("1") ||
                                selectedButtonsList.contains("2"))
                            ? showLabel(
                                "account_upgrade.lbl_phone_number_label".tr())
                            : Container(),
                        _buildrequestNumberEditView(),
                        SizedBox(
                          height: unitWidth * 30,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          bottomSheet: /*  (widget.item != null)
              ? (requestController!.text.toString() != "" &&
                      formObject !=
                          'request.lbl_select_city1'.toString().tr() &&
                      selectedButtonsList.length != 0)
                  ? SafeArea(
                      minimum: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: Container(
                        height: 40 * unitWidth,
                        width: deviceWidth,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: primaryDark),
                            onPressed: () {
                              if (isFirstRequest != null &&
                                  isFirstRequest!.isNotEmpty &&
                                  isFirstRequest == "1") {
                                activateStatus = 1;
                                onSubmit(activateStatus);
                              } else {
                                showActivateDeactivateDialog(context);
                              }
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    'addproperty.lbl_update',
                                    style: TextStyle(
                                      color: lightColor,
                                      fontSize: pageIconSize,
                                    ),
                                  ).tr(),
                                  SizedBox(width: 5),
                                  if (context.locale.toString() == "en_US")
                                    Icon(
                                      forwardArrow,
                                      color: lightColor,
                                    ),
                                  if (context.locale.toString() == "ar_AR")
                                    Icon(
                                      backArrow,
                                      color: lightColor,
                                    )
                                ],
                              ),
                            )),
                      ),
                    )
                  : null
              : */
              (isButtonEnabled1! &&
                      isButtonEnabled2! &&
                      isButtonEnabled3! &&
                      formObject !=
                          'request.lbl_select_city1'.toString().tr() &&
                      selectedButtonsList.isNotEmpty)
                  ? SafeArea(
                      minimum: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: SizedBox(
                        height: 40 * unitWidth,
                        width: deviceWidth,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: primaryDark),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (isFirstRequest != null &&
                                    isFirstRequest!.isNotEmpty &&
                                    isFirstRequest == "1") {
                                  activateStatus = 1;
                                  onSubmit(activateStatus);
                                } else {
                                  showActivateDeactivateDialog(context);
                                }
                              }
                            },
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  Text(
                                    'emailModal.lbl_emailModal_submit',
                                    style: TextStyle(
                                      color: lightColor,
                                      fontSize: pageIconSize,
                                    ),
                                  ).tr(),
                                  const SizedBox(width: 5),
                                  if (context.locale.toString() == "en_US")
                                    const Icon(
                                      forwardArrow,
                                      color: lightColor,
                                    ),
                                  if (context.locale.toString() == "ar_AR")
                                    const Icon(
                                      backArrow,
                                      color: lightColor,
                                    )
                                ],
                              ),
                            )),
                      ),
                    )
                  : null,
        ),
      ),
    );
  }

  Widget _buildrequestEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: InputField(
        textInputAction: TextInputAction.next,
        focusNode: descNode,
        height: unitWidth * 5,
        width: double.infinity,
        controller: requestController,
        borderColor: greyColor.withOpacity(0.6),
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: blackColor,
        hint: 'request.lbl_desc'.tr(),
        hintColor: greyColor,
        hintSize: pageIconSize,
        errorSize: pageIconSize,
        label: '',
        onChanged: (value) {
          setState(() {
            if (value.toString().isNotEmpty) {
              isButtonEnabled1 = true;
            } else {
              isButtonEnabled1 = false;
            }
          });
        },
        validator: (value) {
          return (value!.toString().trim() == '')
              ? 'request.lbl_desc_required'.tr()
              : null;
        },
        labelColor: darkColor.withOpacity(0.8),
        labelSize: pageIconSize,
        maxLines: 4,
      ),
    );
  }

  Widget _buildrequestBudgetEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: InputField(
        textInputAction: TextInputAction.next,
        focusNode: budgetNode,
        height: unitWidth * 18,
        width: double.infinity,
        controller: requestBudgetController,
        borderColor: greyColor,
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: blackColor,
        hint: '${'currency.AED'.tr()} ${'request.lbl_price'.tr()}',
        hintColor: greyColor.withOpacity(0.6),
        hintSize: pageIconSize,
        label: '',
        labelColor: darkColor.withOpacity(0.8),
        labelSize: pageIconSize,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[\u0660-\u06690-9]'))
        ],
        keyboardType: TextInputType.number,
        validator: (String? value) {},
      ),
    );
  }

  Widget _buildLocationInput() {
    return DropDownStatic(
      city: selectOneCity,
      deviceWidth: deviceWidth,
      label: '',
      pageHPadding: pageHPadding,
      selectedDropDownValue: formObject,
      unitWidth: unitWidth,
      onChanged: (value) {
        setState(() {
          formObject = value;
          if (value != '0') {
            isButtonEnabled3 = true;
          } else {
            isButtonEnabled3 = false;
          }
        });
      },
    );
  }

  Widget _buildrequestNumberEditView() {
    return (selectedButtonsList.contains("1") ||
            selectedButtonsList.contains("2"))
        ? Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: IntlPhoneField(
                focusNode: phoneNumberNode,
                flagsButtonPadding: (context.locale.toString() == "en_US")
                    ? const EdgeInsets.only(left: 18)
                    : const EdgeInsets.only(right: 18),
                dropdownIconPosition: (context.locale.toString() == "en_US")
                    ? IconPosition.trailing
                    : IconPosition.leading,
                textInputAction: TextInputAction.done,
                initialValue: requestNumberController!.text,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                decoration: const InputDecoration(
                  // labelText: "account_upgrade.lbl_phone_number_label".tr(),
                  fillColor: Colors.white,
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor)),
                  filled: false,
                ),
                initialCountryCode: 'AE',
                onChanged: (phone) {
                  phoneNumber = "${phone.number}";

                  requestNumberController!.text = phoneNumber.toString();

                  setState(() {
                    if (phone.number.toString().isNotEmpty) {
                      isButtonEnable4 = true;
                    } else {
                      isButtonEnable4 = false;
                    }
                  });
                },
                onCountryChanged: (country) {
                  countryCode = country.dialCode;
                  requestNumberController!.text =
                      "${requestNumberController!.text}";
                },
              ),
            ),
          )
        : Container();
  }

  _buildRequestTypeButton() {
    return SafeArea(
        minimum: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          buildTypesButtonWigdet(selectedButtonsList, "1",
              'propertyDetails.lbl_property_callnow', contactUsIcon),
          const SizedBox(
            width: 5,
          ),
          buildTypesButtonWigdet(selectedButtonsList, "2",
              'propertyDetails.lbl_property_WhatsApp', wpIcon),
          const SizedBox(
            width: 5,
          ),
          buildTypesButtonWigdet(
              selectedButtonsList, "3", 'my_request.Message', messageIcon),
        ]));
  }

  _launchWhatsapp(String? phone, String? msg) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(msg!)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(msg!)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  message(String number) async {
    Uri sms = Uri.parse('sms:$number?body=your+text+here');
    if (await launchUrl(sms)) {
      //app opened
    } else {
      //app is not opened
    }
  }

  Future<void> showActivateDeactivateDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "request.lbl_activate_request_confirmation",
              style: TextStyle(color: blackColor),
            ).tr(),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (isFirstRequest != null &&
                      isFirstRequest!.isNotEmpty &&
                      isFirstRequest == "1") {
                    activateStatus = 1;
                    onSubmit(activateStatus);
                    Navigator.pop(context, false);
                  } else {
                    Navigator.pop(context, false);
                    showPreviousRequestDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
                child: const Text("request.lbl_activate").tr(),
              ),
              OutlinedButton(
                onPressed: () {
                  activateStatus = 0;
                  onSubmit(activateStatus);
                  Navigator.pop(context, false);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: const Text(
                  "request.lbl_cancel",
                  style: TextStyle(color: primaryDark),
                ).tr(),
              ),
            ],
          );
        });
  }

  Future<void> showPreviousRequestDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "request.lbl_previous_request_not_active",
              style: TextStyle(color: blackColor),
            ).tr(),
            actions: [
              ElevatedButton(
                onPressed: () {
                  activateStatus = 1;
                  onSubmit(activateStatus);
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
                child: const Text("request.lbl_submit_label").tr(),
              ),
              OutlinedButton(
                onPressed: () {
                  activateStatus = 0;
                  onSubmit(activateStatus);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: const Text(
                  "request.lbl_cancel",
                  style: TextStyle(color: primaryDark),
                ).tr(),
              ),
            ],
          );
        });
  }

  buildTypesButtonWigdet(
      List<String> selectedButtonsList,
      String contactTypeValue,
      String contactTypeName,
      IconData contactTypeicon) {
    return Expanded(
        child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(
            width: 0.4, // the thickness
            color: greyColor // the color of the border
            ),
        backgroundColor: (selectedButtonsList.contains(contactTypeValue))
            ? primaryDark
            : lightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () {
        if (contactTypeValue != '3') {
          (selectedButtonsList.contains(contactTypeValue))
              ? selectedButtonsList.remove(contactTypeValue)
              : selectedButtonsList.add(contactTypeValue);
          setState(() {});
        }
      },
      icon: Icon(contactTypeicon,
          color: (selectedButtonsList.contains(contactTypeValue))
              ? lightColor
              : darkColor,
          size: pageIconSize),
      label: Text(
        contactTypeName,
        style: TextStyle(
            color: (selectedButtonsList.contains(contactTypeValue))
                ? lightColor
                : darkColor,
            fontSize: 9),
      ).tr(),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
