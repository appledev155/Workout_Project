import 'dart:convert';
import 'dart:io';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/data.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/icon_text_button.dart';
import 'package:anytimeworkout/repository/item_api_provider.dart';
import 'package:anytimeworkout/views/components/center_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class WhatsAppMeCard extends StatelessWidget {
  final MessageRow messageRow;
  const WhatsAppMeCard({super.key, required this.messageRow});

  _launchWhatsapp(String phone, String msg) async {
    phone = phone.replaceAll(' ', '');
    String url = (Platform.isIOS)
        ? "whatsapp://wa.me/$phone/?text=${Uri.parse(msg)}"
        : "whatsapp://send?phone=$phone&text=${Uri.parse(msg)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      await launchUrl(
        Uri.parse(
            "https://api.whatsapp.com/send?phone=$phone&text=${Uri.parse(msg)}"),
        mode: LaunchMode.platformDefault,
      );
    }
  }

  getVerifiedPhoneNumber(MessageRow messageRow) async {
    MessageContent messageContent = MessageContent.fromJson(
        jsonDecode(messageRow.message.content.toString()));
    dynamic messageString = messageContent.data;
    dynamic userId = messageString['userId'];
    String verifiedNumberWithCountryCode = "";
    // get user details api call
    final getUserDetails =
        await app_instance.itemApiProvider.getUserProfile(userId.toString());

    if (getUserDetails.containsKey('phoneNumber') &&
        getUserDetails['phoneNumber'] != null) {
      dynamic phoneNumber = getUserDetails['phoneNumber'];
      dynamic getDialCode = phoneNumber.substring(0, 3);
      if (dialCodes.contains(getDialCode.toString())) {
        verifiedNumberWithCountryCode =
            "+971 ${phoneNumber.toString().substring(1)}";
      } else {
        verifiedNumberWithCountryCode = "+91 ${phoneNumber.toString()}";
      }
      return verifiedNumberWithCountryCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    MessageContent messageContent = MessageContent.fromJson(
        jsonDecode(messageRow.message.content.toString()));
    dynamic messageString = messageContent.data;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            locale: const Locale("en", ''),
            "chat_section.lbl_contact_me_whats_app".tr(),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Text(
            locale: const Locale("ar", ''),
            "chat_section.lbl_contact_me_whats_app".tr(),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: IconTextButton(
              title: 'chat_section.lbl_whatsapp'.tr(),
              iconData: wpIcon,
              titleSize: textSmallSize,
              iconSize: pageTitleSize,
              titleColor: lightColor,
              iconColor: lightColor,
              buttonColor: primaryColor,
              borderColor: primaryDark,
              radius: unitWidth * 5,
              itemSpace: unitWidth,
              onPressed: () async {
                CenterLoader.show(context);
                try {
                  String userPhoneNumber =
                      await getVerifiedPhoneNumber(messageRow);
                  if (userPhoneNumber != "") {
                    CenterLoader.hide(context);
                  }
                  _launchWhatsapp(userPhoneNumber.toString(), 'Hello');
                } catch (er) {
                  CenterLoader.hide(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
