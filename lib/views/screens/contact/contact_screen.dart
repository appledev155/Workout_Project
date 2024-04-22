import 'dart:io';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../views/components/center_loader.dart';
import '../../../views/components/root_redirect.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../bloc/contact_form/contact_form_bloc.dart';

class ContactScreen extends StatefulWidget {
  final String? successMsg;

  ContactScreen({Key? key, this.successMsg}) : super(key: key);
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String? succesMsg;
  String? _whatsapp;
  ContactFormBloc? contactFormBloc;
  _ContactScreenState({this.succesMsg});

  initState() {
    super.initState();
    contactFormBloc = BlocProvider.of<ContactFormBloc>(context);
    getWpNumber();
  }

  getWpNumber() async {
    final tempData = await Notify().getArguments();
    _whatsapp = tempData['WHATSAPP'];
    setState(() {});
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'contactus.lbl_contactus'.tr());
  }

  _launchWhatsapp(String phone, String msg) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(msg)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(msg)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  /* 
 Top of Page : need to design

  <h5 class="ion-text-uppercase">{{translate.instant('contactus.lbl_ask_us_anything')}}</h5>
		<p>{{translate.instant('contactus.lbl_ask_us_anything_desc1')}} {{translate.instant('contactus.lbl_ask_us_anything_desc2')}}</p>
		<p class="ion-text-center">{{translate.instant('contactus.lbl_all_fields_required')}}</p> */

  @override
  Widget build(BuildContext context) {
    double btnSize = MediaQuery.of(context).size.width / 8;
    btnSize = (btnSize < 80) ? 80 : btnSize;
    bool shouldPop = true;

    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(
            'contactus.lbl_contactus',
            style: TextStyle(color: blackColor),
          ).tr(),
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: lightColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.dark),
          elevation: 1,
          backgroundColor: primaryColor,
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
                  onPressed: () => Navigator.pushNamed(context, '/more_drawer'))
              : null,
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: FormBlocListener<ContactFormBloc, String, String>(
                onSubmitting: (context, state) {
                  // CenterLoader.show(context);
                },
                onSuccess: (context, state) {
                  CenterLoader.hide(context);
                  contactFormBloc!.clear();
                  Fluttertoast.showToast(
                      msg: 'settings.contact_success_msg'.tr(),
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 5);
                  RootRedirect.successMsg(
                      context, 'settings.contact_success_msg'.tr(), '');
                },
                onFailure: (context, state) {
                  CenterLoader.hide(context);
                  Fluttertoast.showToast(
                      msg: state.failureResponse!,
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 5);
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: lightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('contactus.lbl_ask_us_anything',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: blackColor,
                                          fontWeight: FontWeight.w500))
                                  .tr(),
                              const SizedBox(height: 10),
                              const Text(
                                'contactus.lbl_ask_us_anything_desc1',
                                style: TextStyle(color: blackColor),
                              ).tr(),
                              const SizedBox(height: 2),
                              const Text(
                                'contactus.lbl_ask_us_anything_desc2',
                                maxLines: 3,
                                style: TextStyle(color: blackColor),
                              ).tr(),
                              const SizedBox(height: 10),
                              Align(
                                  alignment: Alignment.center,
                                  child: const Text(
                                          'contactus.lbl_all_fields_required',
                                          style: TextStyle(color: primaryColor))
                                      .tr()),
                              const SizedBox(height: 15),
                              TextFieldBlocBuilder(
                                textFieldBloc: contactFormBloc!.nameField,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(right: 20.0),
                                  filled: true,
                                  fillColor: greyColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText: 'contactus.lbl_contactus_name'.tr(),
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    color: blackColorLight,
                                  ),
                                  prefixIcon: const Icon(
                                    personIcon,
                                    color: blackColorLight,
                                  ),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: contactFormBloc!.emailField,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(right: 20.0),
                                  filled: true,
                                  fillColor: greyColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText:
                                      'contactus.lbl_contactus_email'.tr(),
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    color: blackColorLight,
                                  ),
                                  prefixIcon: const Icon(
                                    mailIcon,
                                    color: blackColorLight,
                                  ),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: contactFormBloc!.phoneField,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(right: 20.0),
                                  filled: true,
                                  fillColor: greyColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText:
                                      'contactus.lbl_contactus_phone'.tr(),
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    color: blackColorLight,
                                  ),
                                  prefixIcon: const Icon(
                                    contactUsIcon,
                                    color: blackColorLight,
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[\u0660-\u06690-9]'))
                                ],
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: contactFormBloc!.messageField,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(right: 20.0),
                                  filled: true,
                                  fillColor: greyColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText:
                                      'contactus.lbl_contactus_message'.tr(),
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    color: blackColorLight,
                                  ),
                                  prefixIcon: const Icon(
                                    textIcon,
                                    color: blackColorLight,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // const Text('').tr(),
                              Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    onPressed: contactFormBloc!.submit,
                                    icon:
                                        const Icon(mailIcon, color: lightColor),
                                    label: const Text(
                                      'contactus.lbl_contactus_send',
                                      style: TextStyle(
                                          color: lightColor, fontSize: 16),
                                    ).tr(),
                                  ))
                            ],
                          )),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: lightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                      'propertyDetails.lbl_property_WhatsApp',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: blackColor,
                                          fontWeight: FontWeight.w500))
                                  .tr(),
                              const SizedBox(height: 10),
                              const Text(
                                'contactus.lbl_contactus_givecall_desc',
                                style: TextStyle(color: blackColor),
                              ).tr(),
                              const SizedBox(height: 20),
                              Align(
                                  alignment: Alignment.center,
                                  child: const Text(
                                          'contactus.lbl_contactus_number',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 16))
                                      .tr()),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () =>
                                      _launchWhatsapp(_whatsapp!, 'Hello'),
                                  icon: const Icon(
                                    wpIcon,
                                    color: lightColor,
                                  ),
                                  label: const Text(
                                    'contactus.lbl_contactus_give_call',
                                    style: TextStyle(
                                        color: lightColor, fontSize: 16),
                                  ).tr(),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: lightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('contactus.lbl_contactus_walkin',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: blackColor,
                                            fontWeight: FontWeight.w500))
                                    .tr(),
                                const SizedBox(height: 20),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'contactus.lbl_contactus_walkin_desc1',
                                        style: TextStyle(
                                            color: blackColor,
                                            fontSize: pageTextSize),
                                      ).tr(),
                                      Text(
                                        'contactus.lbl_contactus_walkin_desc2',
                                        style: TextStyle(
                                            color: blackColor,
                                            fontSize: pageTextSize),
                                      ).tr(),
                                    ]),
                                const SizedBox(height: 30),
                                Align(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'contactus.lbl_contactus_add1',
                                      style: TextStyle(
                                          color: blackColor,
                                          fontWeight: FontWeight.w500),
                                    ).tr()),
                                const SizedBox(height: 3),
                                Align(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'contactus.lbl_contactus_add2',
                                      style: TextStyle(
                                          color: blackColor,
                                          fontWeight: FontWeight.w500),
                                    ).tr()),
                                const SizedBox(height: 3),
                                Align(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'contactus.lbl_contactus_add3',
                                      style: TextStyle(
                                          color: blackColor,
                                          fontWeight: FontWeight.w500),
                                    ).tr()),
                              ])),
                      const SizedBox(height: 10)
                    ],
                  ),
                ))),
      ),
    );
  }
}
//🔥 Reset locale resetLocale() #

/* 
botttom design remain..

let contact_number = GlobalVariable.whatsAppNumber;
this.whatsAppNumber = contact_number.replace('+','');

 <ion-card class="background-white ion-padding ion-margin-bottom">
		<h5>{{translate.instant('contactus.lbl_contactus_give_call')}}</h5>
		<p>{{translate.instant('contactus.lbl_contactus_givecall_desc')}}</p>
		<div class="ion-text-center font-size-1">

			<ion-label color="success">{{translate.instant('contactus.lbl_contactus_add3')}}</ion-label>
		</div>
		<div class="ion-text-center ion-margin-top">
			
		<ion-button  color="success" href="whatsapp://send?phone={{whatsAppNumber}}" >
			<ion-icon name="call" class="ion-margin-end forRTL"></ion-icon>{{translate.instant('contactus.lbl_contactus_call')}}</ion-button>
 

		</div>
	</ion-card>
	<ion-card class="background-white ion-padding ion-margin-bottom">
		<h5>{{translate.instant('contactus.lbl_contactus_walkin')}}</h5>
		<p>{{translate.instant('contactus.lbl_contactus_walkin_desc1')}}
		{{translate.instant('contactus.lbl_contactus_walkin_desc2')}}</p>
		<div class="ion-text-center">
			<p>
				<strong>{{translate.instant("appName."+appName)}}<br />
				{{websiteName}}<br />
				{{translate.instant('contactus.lbl_contactus_add3')}}</strong>
			</p>
		</div>
	</ion-card>  */
