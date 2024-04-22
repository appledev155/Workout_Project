import 'dart:io';

import 'package:anytimeworkout/config/icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/contact_form/contact_form_bloc.dart';
import '../../../config/app_colors.dart';
import '../../components/notify.dart';

class ErrorInfoScreen extends StatefulWidget {
  const ErrorInfoScreen({super.key, this.errorType = ""});
  final String errorType;

  @override
  State<StatefulWidget> createState() {
    return ErrorInfoScreenState();
  }
}

class ErrorInfoScreenState extends State<ErrorInfoScreen> {
  String? _whatsapp;
  ContactFormBloc? contactFormBloc;

  @override
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/verfied_numbers');
        return true;
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
              title: const Text(''),
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              elevation: 1,
              backgroundColor: lightColor,
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
                    Navigator.pushNamed(context, '/verfied_numbers'),
              )),
          body: Container(
            color: lightColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                (widget.errorType == "terminateRequest")
                    ? Column(
                        children: [
                          const Text('settings.terminate_req',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: favoriteColor,
                                      fontWeight: FontWeight.w500))
                              .tr(),
                          const SizedBox(height: 10),
                        ],
                      )
                    : Column(
                        children: [
                          const Text('settings.many_attempt',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: greenColor,
                                      fontWeight: FontWeight.w500))
                              .tr(),
                          const SizedBox(height: 10),
                        ],
                      ),
                (widget.errorType == "terminateRequest")
                    ? Column(
                        children: [
                          const Text("settings.terminate_call",
                              style: TextStyle(
                                color: greenColor,
                              )).tr(),
                          const Text(
                            "settings.try_again",
                            style: TextStyle(
                              color: greenColor,
                            ),
                          ).tr(),
                          const SizedBox(height: 10),
                          const Divider(),
                          const Text(
                            'contactus.lbl_contactus_givecall_desc',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: greenColor,
                            ),
                          ).tr(),
                        ],
                      )
                    : const Text(
                        'contactus.lbl_contactus_givecall_desc',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: greenColor),
                      ).tr(),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        backgroundColor: primaryDark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    onPressed: () => _launchWhatsapp(_whatsapp!, 'Hello'),
                    icon: const Icon(
                      wpIcon,
                      color: lightColor,
                    ),
                    label: const Text(
                      'contactus.lbl_contactus_give_call',
                      style: TextStyle(color: lightColor, fontSize: 16),
                    ).tr(),
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          )),
    );
  }
}
