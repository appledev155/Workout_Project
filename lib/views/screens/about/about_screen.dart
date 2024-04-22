import 'dart:io';

import 'package:anytimeworkout/config/icons.dart';

import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
                  icon: Icon(
                    (context.locale.toString() == "en_US")
                        ? (Platform.isIOS)
                            ? iosBackButton
                            : backArrow
                        // : (context.locale.toString() == "ar_AR")
                        //     ? (Platform.isIOS)
                        //         ? iosForwardButton
                        //         : forwardArrow
                            : iosForwardButton,
                    color: blackColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          elevation: 1,
          backgroundColor: primaryColor,
          title: const Text(
            'aboutus.lbl_aboutus',
            style: TextStyle(color: blackColor),
          ).tr(),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 30),
              Center(
                  child: const Text(
                'contactus.lbl_contactus_add1',
                style: TextStyle(fontSize: 30),
              ).tr()),
              const SizedBox(height: 40),
              const Text('aboutus.lbl_who_we_are',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                  .tr(),
              const SizedBox(height: 20),
              const Text('aboutus.lbl_aboutus_desc1',
                      style: TextStyle(fontSize: 16))
                  .tr(),
              const SizedBox(height: 12),
              const Text('aboutus.lbl_aboutus_desc2',
                      style: TextStyle(fontSize: 16))
                  .tr(),
              const SizedBox(height: 12),
              const Text('aboutus.lbl_aboutus_desc3',
                      style: TextStyle(fontSize: 16))
                  .tr(),
              const SizedBox(height: 12),
              const Text('aboutus.lbl_aboutus_desc4',
                      style: TextStyle(fontSize: 16))
                  .tr()
            ])));
  }
}
