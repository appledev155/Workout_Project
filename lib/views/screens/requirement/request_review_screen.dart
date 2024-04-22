import 'package:anytimeworkout/model/user_model.dart';

import '../../../views/components/forms/text_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import '../../components/forms/input_field_prefix.dart';
import '../../components/forms/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import '../../../views/components/center_loader.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class RequestReviewScreen extends StatefulWidget {
  final int? contact;
  final String? description;
  final String? budget;
  final String? city;
  final String? number;

  const RequestReviewScreen(
      {super.key,
      this.contact,
      this.description,
      this.budget,
      this.city,
      this.number});

  @override
  _RequestReviewScreenState createState() => _RequestReviewScreenState();
}

class _RequestReviewScreenState extends State<RequestReviewScreen> {
  String? stripeMerchantId;
  String? stripePublishableKey;
  String? stripeAndroidPayMode;
  int? stripeAmount;
  String? stripeCurrency;
  String? amount;
  String? countryCode;
  double? cost;
  double? tip;
  double? tax;
  double? taxPercent;
  String? stripeCurrencySign;
  dynamic token;
  bool? isLoaded;

  final _host = dotenv.env['HOST'];

  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryMonthController = TextEditingController();
  TextEditingController cardExpiryYearController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();

  bool showSpinner = false;
  String text = 'Click the button to start the payment';
  String? url;

  void initState() {
    super.initState();
    url = 'https://${_host!}/api/stripepi';
    //onInit();
    cardNumberController.addListener(() {
      var baseOffset = cardNumberController.value.selection.baseOffset;
      var extentOffset = cardNumberController.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        cardNumberController.value = cardNumberController.value.copyWith(
          text: cardNumberController.text
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
              baseOffset: cardNumberController.text.length,
              extentOffset: cardNumberController.text.length),
          composing: TextRange.empty,
        );
      }
    });
    cardExpiryMonthController.addListener(() {
      var baseOffset = cardExpiryMonthController.value.selection.baseOffset;
      var extentOffset = cardExpiryMonthController.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        cardExpiryMonthController.value =
            cardExpiryMonthController.value.copyWith(
          text: cardExpiryMonthController.text
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
              baseOffset: cardExpiryMonthController.text.length,
              extentOffset: cardExpiryMonthController.text.length),
          composing: TextRange.empty,
        );
      }
    });
    cardExpiryYearController.addListener(() {
      var baseOffset = cardExpiryYearController.value.selection.baseOffset;
      var extentOffset = cardExpiryYearController.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        cardExpiryYearController.value =
            cardExpiryYearController.value.copyWith(
          text: cardExpiryYearController.text
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
              baseOffset: cardExpiryYearController.text.length,
              extentOffset: cardExpiryYearController.text.length),
          composing: TextRange.empty,
        );
      }
    });
    cardCvvController.addListener(() {
      var baseOffset = cardCvvController.value.selection.baseOffset;
      var extentOffset = cardCvvController.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        cardCvvController.value = cardCvvController.value.copyWith(
          text: cardCvvController.text
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
              baseOffset: cardCvvController.text.length,
              extentOffset: cardCvvController.text.length),
          composing: TextRange.empty,
        );
      }
    });
  }

  onSubmitting() async {
    UserModel currentUser = await app_instance.utility.jwtUser();
    String? description = widget.description;
    String? number = widget.number;
    String contact = widget.contact.toString();
    String? budget = widget.budget;
    String? city = widget.city;
    String? userId = currentUser.id.toString();
    String? stripeCustomerId =
        await app_instance.storage.read(key: 'stripeCustomerId');
    String? paymentIntentId =
        await app_instance.storage.read(key: 'paymentIntentId');

    Object requestInfo = {
      'token': token.toString(),
      'description_ar':
          (context.locale.toString() == 'ar_AR') ? description.toString() : '',
      'description_en':
          (context.locale.toString() == 'en_US') ? description.toString() : '',
      'phone': number.toString(),
      'budget': budget.toString(),
      'location': city.toString(),
      'contact_type': contact.toString(),
      'amount': stripeAmount.toString(),
      'user_id': (userId != null) ? userId.toString() : '',
      'name': cardNameController.text,
      'stripeCustomerId': stripeCustomerId.toString(),
      'paymentIntentId': paymentIntentId.toString()
    };
    await app_instance.userRepository.requestPropAdd(requestInfo);
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoaded == true)
        ? Scaffold(
            backgroundColor: lightColor,
            appBar: AppBar(
              title: const Text(
                'request.lbl_send_request',
                style: TextStyle(color: blackColor),
              ).tr(),
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('request.lbl_view_request1',
                                textDirection: ui.TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: pageIconSize,
                                    fontWeight: FontWeight.w500))
                            .tr()),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(1.5, 2, 1.5, 3),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: greyColor.withOpacity(0.4),
                                  blurRadius: 0.5,
                                  spreadRadius: 0.1,
                                  offset: const Offset(0, 0.1))
                            ],
                            color: lightColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (widget.description != null)
                                  ? widget.description!
                                  : '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: pageIconSize),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'request.lbl_city'.tr(),
                                      style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontSize: pageTextSize,
                                          color: blackColor)),
                                  const TextSpan(
                                      text: ' : ',
                                      style: TextStyle(color: greyColor)),
                                  TextSpan(
                                      text: 'cityArray.${widget.city}'.tr(),
                                      style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontSize: pageTextSize,
                                          color: blackColor))
                                ])),
                                if (widget.budget!.isNotEmpty)
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'request.lbl_budget'.tr(),
                                        style: TextStyle(
                                            fontFamily: 'DM Sans',
                                            fontSize: pageTextSize,
                                            color: blackColor)),
                                    const TextSpan(
                                        text: ' : ',
                                        style: TextStyle(color: greyColor)),
                                    TextSpan(
                                        text:
                                            '${widget.budget!} ${'currency.AED'.tr()}',
                                        style: TextStyle(
                                            fontFamily: 'DM Sans',
                                            fontSize: pageTextSize,
                                            color: blackColor))
                                  ]))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (widget.contact == 1) _buildWhatsappButton(),
                            if (widget.contact == 2) _buildCallButton(),
                            if (widget.contact == 3)
                              Row(children: [
                                Expanded(child: _buildWhatsappButton()),
                                Expanded(child: _buildCallButton())
                              ])
                          ],
                        )),
                    SizedBox(
                      height: unitWidth * 17,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('request.lbl_phone_number',
                                textDirection: ui.TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: pageIconSize,
                                    fontWeight: FontWeight.w500))
                            .tr()),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(widget.number!,
                            textDirection: ui.TextDirection.ltr,
                            style: TextStyle(
                                fontSize: pageTitleSize,
                                fontWeight: FontWeight.bold))),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'request.lbl_amount',
                              style: TextStyle(
                                  fontSize: pageIconSize,
                                  fontWeight: FontWeight.w500),
                            ).tr(),
                            Text(stripeCurrencySign! + amount.toString(),
                                style: TextStyle(
                                    fontSize: pageIconSize,
                                    fontWeight: FontWeight.w500))
                          ],
                        ))
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
                minimum: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(child: _buildCardPayButton()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNativePayButton())
                  ],
                )),
          )
        : Scaffold(
            backgroundColor: lightColor,
            appBar: AppBar(
              title: const Text(
                'request.lbl_send_request',
                style: TextStyle(color: blackColor),
              ).tr(),
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: lightColor,
              iconTheme: const IconThemeData(color: blackColor),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ));
  }

  Widget _buildNativePayButton() {
    return Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
          width: deviceWidth,
          child: TextIconButton(
            title: 'request.lbl_pay_button'.tr(),
            iconData: (Platform.isIOS) ? aIcon : gIcon,
            titleSize: pageIconSize,
            iconSize: pageIconSize,
            titleColor: lightColor,
            iconColor: lightColor,
            buttonColor: (Platform.isIOS) ? blackColor : primaryDark,
            borderColor: (Platform.isIOS) ? blackColor : primaryDark,
            radius: unitWidth * 5,
            itemSpace: unitWidth * 4,
            onPressed: () {
              CenterLoader.show(context);
              //checkIfNativePayReady();
            },
          ),
        ));
  }

  Widget _buildCardPayButton() {
    return Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
            width: deviceWidth,
            child: TextIconButton(
                title: 'request.lbl_pay_button'.tr(),
                iconData: cardIcon,
                titleSize: pageIconSize,
                iconSize: pageIconSize,
                titleColor: primaryDark,
                iconColor: primaryDark,
                buttonColor: lightColor,
                borderColor: primaryDark,
                radius: unitWidth * 5,
                itemSpace: unitWidth * 4,
                onPressed: () {
                  showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    builder: (context) => modelBottomSheet(),
                  );
                })));
  }

  Widget _buildWhatsappButton() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: TextIconButton(
        title: 'propertyDetails.lbl_property_WhatsApp'.tr(),
        iconData: wpIcon,
        titleSize: pageIconSize,
        iconSize: pageTitleSize,
        titleColor: lightColor,
        iconColor: lightColor,
        buttonColor: primaryColor,
        borderColor: primaryColor,
        radius: unitWidth * 5,
        itemSpace: unitWidth,
        onPressed: () {},
      ),
    );
  }

  Widget _buildCallButton() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: TextIconButton(
        title: 'propertyDetails.lbl_property_callnow'.tr(),
        iconData: contactUsIcon,
        titleSize: pageIconSize,
        iconSize: pageTitleSize,
        titleColor: primaryDark,
        iconColor: primaryDark,
        buttonColor: lightColor,
        borderColor: primaryDark,
        radius: unitWidth * 5,
        itemSpace: unitWidth * 4,
        onPressed: () {},
      ),
    );
  }

  Widget modelBottomSheet() {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'request.lbl_card',
                    style: TextStyle(
                        fontSize: pageTitleSize, fontWeight: FontWeight.bold),
                  ).tr()),
              _buildUserNameView(),
              _buildrequestEditView(),
              _buildrequestCardDetailsEditView(),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: Text(
                      '${'request.lbl_amount'.tr()} ${stripeCurrencySign!}$amount',
                      style: TextStyle(
                          fontSize: pageTitleSize,
                          fontWeight: FontWeight.w500))),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                      text: TextSpan(
                          text: '${'request.lbl_policy_agreement'.tr()} ',
                          style: const TextStyle(
                              color: blackColor, fontFamily: 'DM Sans'),
                          children: [
                        TextSpan(
                            text: 'register.lbl_terms_cond'.tr(),
                            style: const TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                                fontFamily: 'DM Sans'),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launch(
                                  'https://uaeaqar.com/privacy-policy.html'))
                      ]))),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: primaryDark),
                onPressed: () {
                  CenterLoader.show(context);
                  //createPaymentMethod();
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'request.lbl_pay_button',
                        style: TextStyle(
                          color: lightColor,
                          fontSize: pageIconSize,
                        ),
                      ).tr()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildUserNameView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      // ignore: missing_required_param
      child: InputField(
        height: unitWidth * 15,
        width: double.infinity,
        controller: cardNameController,
        borderColor: greyColor.withOpacity(0.6),
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: darkColor,
        hint: 'request.lbl_carholder_name'.tr(),
        hintColor: greyColor.withOpacity(0.6),
        hintSize: pageIconSize,
        label: '',
        labelColor: darkColor.withOpacity(0.8),
        labelSize: pageIconSize,
      ),
    );
  }

  Widget _buildrequestEditView() {
    return Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
          width: deviceWidth,
          padding: EdgeInsets.symmetric(horizontal: pageHPadding),
          child: InputFieldPrefix(
            height: unitWidth * 15,
            width: double.infinity,
            controller: cardNumberController,
            borderColor: greyColor.withOpacity(0.6),
            radius: unitWidth * 5,
            fontSize: pageIconSize,
            fontColor: darkColor,
            hint: 'request.lbl_card_number'.tr(),
            hintColor: greyColor.withOpacity(0.6),
            hintSize: pageIconSize,
            label: '',
            labelColor: darkColor.withOpacity(0.8),
            labelSize: pageIconSize,
            prefixIcon: cardIcon,
            prefixIconColor: greyColor.withOpacity(0.6),
            prefixIconSize: unitWidth * 25,
            keyboardType: TextInputType.number,
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: '#### #### #### ####',
                  filter: {"#": RegExp('[\u0660-\u06690-9]')})
            ],
          ),
        ));
  }

  Widget _buildrequestCardDetailsEditView() {
    return Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
          width: deviceWidth,
          padding: EdgeInsets.symmetric(horizontal: pageHPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(mainAxisSize: MainAxisSize.max, children: [
                Row(children: [
                  // ignore: missing_required_param
                  InputField(
                    width: unitWidth * 80,
                    controller: cardExpiryMonthController,
                    borderColor: greyColor,
                    radius: unitWidth * 5,
                    fontSize: pageIconSize,
                    fontColor: darkColor,
                    hint: 'MM',
                    hintColor: greyColor.withOpacity(0.8),
                    hintSize: pageIconSize,
                    textInputAction: TextInputAction.next,
                    label: '',
                    labelColor: greyColor,
                    labelSize: pageIconSize,
                    height: unitWidth * 15,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.allow(
                          RegExp('[\u0660-\u06690-9]'))
                    ],
                  ),
                  const SizedBox(width: 10),
                  // ignore: missing_required_param
                  InputField(
                    width: unitWidth * 80,
                    controller: cardExpiryYearController,
                    borderColor: greyColor,
                    radius: unitWidth * 5,
                    fontSize: pageIconSize,
                    textInputAction: TextInputAction.next,
                    fontColor: darkColor,
                    hint: 'YY',
                    hintColor: greyColor.withOpacity(0.8),
                    hintSize: pageIconSize,
                    label: '',
                    labelColor: greyColor,
                    labelSize: pageIconSize,
                    height: unitWidth * 15,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.allow(
                          RegExp('[\u0660-\u06690-9]'))
                    ],
                  )
                ]),
              ]),
              Column(children: [
                // ignore: missing_required_param
                InputField(
                  width: unitWidth * 130,
                  controller: cardCvvController,
                  borderColor: greyColor,
                  radius: unitWidth * 5,
                  fontSize: pageIconSize,
                  fontColor: darkColor,
                  hint: 'CVV',
                  hintColor: greyColor.withOpacity(0.8),
                  hintSize: pageIconSize,
                  label: '',
                  labelColor: greyColor,
                  labelSize: pageIconSize,
                  height: unitWidth * 15,
                  suffixIcon: Image.asset(
                    'assets/icon/cvv.png',
                    height: pageIconSize,
                  ),
                  minHeight: 30,
                  minWidth: 30,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (cardCvvController.text.length == 3) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.allow(
                        RegExp('[\u0660-\u06690-9]'))
                  ],
                )
              ]),
            ],
          ),
        ));
  }

  _buildMessageButton() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: TextIconButton(
        title: 'propertyDetails.lbl_property_messag'.tr(),
        iconData: contactUsIcon,
        titleSize: pageIconSize,
        iconSize: pageTitleSize,
        titleColor: primaryDark,
        iconColor: primaryDark,
        buttonColor: lightColor,
        borderColor: primaryDark,
        radius: unitWidth * 5,
        itemSpace: unitWidth * 4,
        onPressed: () {},
      ),
    );
  }
}

class ShowDialogToDismiss extends StatelessWidget {
  final String? content;
  final String? title;
  final String? buttonText;
  const ShowDialogToDismiss({this.title, this.buttonText, this.content});
  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: Text(
          title!,
        ),
        content: Text(
          this.content!,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              buttonText!,
            ),
            onPressed: () {
              CenterLoader.hide(context);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title!,
          ),
          content: Text(
            this.content!,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                buttonText![0].toUpperCase() +
                    buttonText!.substring(1).toLowerCase(),
              ),
              onPressed: () {
                CenterLoader.hide(context);
                Navigator.of(context).pop();
              },
            )
          ]);
    }
  }
}
