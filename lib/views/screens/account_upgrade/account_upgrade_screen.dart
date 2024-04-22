import 'dart:io';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/data.dart';
import 'package:anytimeworkout/views/components/static_drop_down.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../bloc/account_upgrade_bloc/account_upgrade_bloc.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import '../../components/center_loader.dart';
import '../../components/forms/input_field.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class AccountUpgradeScreen extends StatefulWidget {
  @override
  State<AccountUpgradeScreen> createState() => _AccountUpgradeScreenState();
}

class _AccountUpgradeScreenState extends State<AccountUpgradeScreen> {
  final bool? adminApproved = false;

  final ScrollController _scroll = ScrollController();

  // Focus Nodes
  final FocusNode agencyNameNode = FocusNode();

  final FocusNode fullNameNode = FocusNode();

  final FocusNode phoneNumberNode = FocusNode();

  final FocusNode cityNode = FocusNode();

  String? formObject = '0';

  // Error Fields
  final Map<String, String> errorFields = {
    "agencyNameFieldError": '',
    "fullNameFieldError": '',
    "phoneNumberFieldError": '',
    "cityFieldError": ''
  };

  // TextEditing Controller
  final TextEditingController agencyNameController = TextEditingController();

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final String? selectedDropDownValue = 'ALL_CITIES';

  // Input Box label
  Widget _buildLabel(label) {
    return Align(
        alignment: (context.locale.toString() == "en_US")
            ? Alignment.topLeft
            : Alignment.topRight,
        child: Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ).tr());
  }

  // Input box widget for agency name --
  Widget _buildAgencyNameInputBox() {
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: Column(
          children: [
            _buildLabel(
                "account_upgrade.lbl_agency_name_label".tr().toString()),
            InputField(
              validator: (p0) {
                if (agencyNameController.text == "") {
                  // agencyNameFieldError = "Please Enter Agency Name";
                  errorFields["agencyNameFieldError"] =
                      "account_upgrade.lbl_agency_name".tr();
                  return errorFields["agencyNameFieldError"];
                }
                return null;
              },
              onChanged: (p0) {},
              focusNode: agencyNameNode,
              height: unitWidth * 15,
              width: double.infinity,
              controller: agencyNameController,
              borderColor: (errorFields["agencyNameFieldError"] == '')
                  ? (adminApproved!)
                      ? greyColor.withOpacity(0.6)
                      : darkColor
                  : greyColor,
              radius: unitWidth * 5,
              fontSize: pageIconSize,
              fontColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
              hint: "account_upgrade.lbl_agency_name_hint".tr().toString(),
              hintColor: darkColor.withOpacity(0.8),
              hintSize: pageIconSize,
              label: '',
              labelColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
              labelSize: pageTextSize,
              readOnly: (adminApproved!) ? true : false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[#_/=@,*;:]')),
              ],
            ),
          ],
        ));
  }

  // Input box widget for first name --
  Widget _buildFullNameInputBox() {
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: Column(
          children: [
            _buildLabel("account_upgrade.lbl_name".tr().toString()),
            InputField(
              validator: (p0) {
                if (fullNameController.text == "") {
                  errorFields["fullNameFieldError"] =
                      "account_upgrade.lbl_firstName".tr();
                  return errorFields["fullNameFieldError"];
                }
                return null;
              },
              focusNode: fullNameNode,
              focusedColor: greyColor,
              height: unitWidth * 15,
              width: double.infinity,
              controller: fullNameController,
              borderColor: (errorFields["fullNameFieldError"] == '')
                  ? (adminApproved!)
                      ? greyColor.withOpacity(0.6)
                      : darkColor
                  : favoriteColor,
              radius: unitWidth * 5,
              fontSize: pageIconSize,
              fontColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
              hint: "account_upgrade.lbl_first_name".tr().toString(),
              hintColor: darkColor.withOpacity(0.8),
              hintSize: pageIconSize,
              label: '',
              labelColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
              labelSize: pageTextSize,
              readOnly: (adminApproved!) ? true : false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[#_/=@,*;:]')),
              ],
            ),
          ],
        ));
  }

  // Input box widget for phone number --
  Widget _buildPhoneNumberInputBox() {
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: Column(
          children: [
            _buildLabel(
                "account_upgrade.lbl_phone_number_label".tr().toString()),
            InputField(
              validator: (p0) {
                if (phoneNumberController.text == "") {
                  errorFields["phoneNumberFieldError"] =
                      "account_upgrade.lbl_phoneNumber_field".tr();
                  return errorFields["phoneNumberFieldError"];
                }
                return null;
              },
              focusNode: phoneNumberNode,
              height: unitWidth * 15,
              width: double.infinity,
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              borderColor: (errorFields["phoneNumberFieldError"] == '')
                  ? (adminApproved!)
                      ? blackColor.withOpacity(0.6)
                      : darkColor
                  : favoriteColor,
              radius: unitWidth * 5,
              fontSize: pageIconSize,
              fontColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
              hint: "account_upgrade.lbl_phone_number_label".tr().toString(),
              hintColor: darkColor.withOpacity(0.8),
              hintSize: pageIconSize,
              label: '',
              labelColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
              labelSize: pageTextSize,
              readOnly: (adminApproved!) ? true : false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[#_/=@,*;:]')),
              ],
            ),
          ],
        ));
  }

  Widget _buildLocationInput() {
    return DropDownStatic(
      city: selectOneCity,
      deviceWidth: deviceWidth,
      pageHPadding: pageHPadding,
      selectedDropDownValue: formObject,
      unitWidth: unitWidth,
      onChanged: (value) {
        setState(() {
          formObject = value.toString();
        });
      },
    );
  }

  // Input box widget for cities --
  Widget _buildCityInputBox() {
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: Column(
          children: [
            _buildLabel("account_upgrade.lbl_city_label".tr().toString()),
            InputField(
              validator: (p0) {
                if (cityController.text == "") {
                  errorFields["cityFieldError"] =
                      "account_upgrade.lbl__cityName".tr();
                  return errorFields["cityFieldError"];
                }
                return null;
              },
              focusNode: cityNode,
              height: unitWidth * 15,
              width: double.infinity,
              controller: cityController,
              borderColor: (errorFields["cityFieldError"] == '')
                  ? (adminApproved!)
                      ? greyColor.withOpacity(0.6)
                      : darkColor
                  : favoriteColor,
              radius: unitWidth * 5,
              fontSize: pageIconSize,
              fontColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
              hint: "account_upgrade.lbl_select_the_city".tr().toString(),
              hintColor: darkColor.withOpacity(0.8),
              hintSize: pageIconSize,
              label: '',
              labelColor:
                  (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
              labelSize: pageTextSize,
              readOnly: (adminApproved!) ? true : false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[#_/=@,*;:]')),
              ],
            ),
          ],
        ));
  }

  Widget _buildDescription() {
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding),
        child: Text("account_upgrade.lbl_description".tr(),
            style:
                TextStyle(fontSize: 15.sp, color: blackColor.withOpacity(0.6)),
            textAlign: TextAlign.justify));
  }

  // Main Widget
  @override
  Widget build(BuildContext context) {
    String location = '_';
    for (var i in selectOneCity) {
      if (i.last.toString() == formObject.toString()) {
        location = i[1].toString().tr();
      }
    }
    cityArray.remove(0);
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/more_drawer');
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: lightColor,
        appBar: AppBar(
          title: const Text(
            'account_upgrade.lbl_title',
            style: TextStyle(color: blackColor),
          ).tr(),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 1,
          backgroundColor: lightColor,
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
                  onPressed: () => Navigator.pushNamed(context, '/more_drawer'),
                )
              : null,
        ),
        body: BlocConsumer<AccountUpgradeBloc, AccountUpgradeState>(
            builder: (context, state) {
          if (state.status == AccountUpgradeStatus.verificationFailure) {
            return Center(
              child: Text(
                "account_upgrade.lbl_account_upgrade_request_sent".tr(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }
          if (state.status == AccountUpgradeStatus.loading) {
            return CenterLoader();
          }
          if (state.status == AccountUpgradeStatus.verificationSuccess ||
              state.status == AccountUpgradeStatus.initial ||
              state.status == AccountUpgradeStatus.failure) {
            return Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                child: SizedBox(
                  child: SingleChildScrollView(
                    controller: _scroll,
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 7, right: 7),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 5),
                          Text(
                            'account_upgrade.lbl_heading',
                            style: TextStyle(
                                color: blackColor,
                                fontSize: pageTitleSize + 1,
                                fontWeight: FontWeight.w700),
                          ).tr(),
                          const SizedBox(height: 30),

                          // input box for Agency Name
                          _buildAgencyNameInputBox(),
                          const SizedBox(height: 25),

                          _buildLocationInput(),
                          const SizedBox(height: 25),

                          _buildFullNameInputBox(),
                          const SizedBox(height: 25),

                          _buildPhoneNumberInputBox(),
                          const SizedBox(height: 25),

                          // Description
                          _buildDescription(),
                          // _buildButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        }, listener: (context, state) {
          if (state.status == AccountUpgradeStatus.success) {
            app_instance.storage
                .write(key: 'LastPage', value: "Account Upgrade");
            CenterLoader.hide(context);
            Fluttertoast.showToast(
                msg: state.message!, toastLength: Toast.LENGTH_SHORT);
            Navigator.pushNamed(context, '/more_drawer');
          }
          if (state.status == AccountUpgradeStatus.failure) {
            Fluttertoast.showToast(msg: state.message!);
          }
        }),
        bottomNavigationBar:
            BlocBuilder<AccountUpgradeBloc, AccountUpgradeState>(
          builder: (context, state) {
            return (state.status == AccountUpgradeStatus.verificationFailure)
                ? Center(
                    child: Text(
                      "account_upgrade.lbl_account_upgrade_request_sent".tr(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : _buildButton(context, location);
          },
        ),
      ),
    );
  }

  _buildButton(BuildContext context, String location) {
    return Container(
        margin: EdgeInsets.all(18.sp),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              CenterLoader.show(context);
              context.read<AccountUpgradeBloc>().add(PostAccountUpgrade(
                  name: fullNameController.text,
                  agencyName: agencyNameController.text,
                  city: location,
                  phone: phoneNumberController.text));
            }
          },
          child: Padding(
            padding: EdgeInsets.all(18.sp),
            child: Text('account_upgrade.lbl_send'.tr().toString()),
          ),
        ));
  }
}
