import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/views/components/forms/text_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../config/app_colors.dart';
import '../../../../../config/styles.dart';
import '../../../model/chat_model.dart';

class SinglePropertyWidget extends StatelessWidget {
  final MessageRow messageRow;
  final String appUserId;
  const SinglePropertyWidget(
      {super.key, required this.messageRow, required this.appUserId});

  @override
  Widget build(BuildContext context) {
    Message getMessage = messageRow.message;
    MessageContent getMessageContent = getMessage.content!;
    dynamic decodedMessageData = jsonDecode(getMessageContent.data);
    dynamic lblRequestLocationAr = "chat_section.lbl_request_location_ar".tr();
    dynamic lblRequestBudgetAr = "chat_section.lbl_request_budget_ar".tr();
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (decodedMessageData.containsKey('message') &&
                  decodedMessageData['message'].toString().isNotEmpty)
              ? Text(decodedMessageData['message'].toString(),
                  style: const TextStyle(
                      height: 2,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                      fontSize: 17))
              : Container(),
          (decodedMessageData.containsKey('location') &&
                  decodedMessageData['location'].toString().isNotEmpty)
              ? RichText(
                  text: TextSpan(
                    text: 'Location: ',
                    style: const TextStyle(
                        height: 2, color: blackColor, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text: decodedMessageData['location'].toString(),
                          style: const TextStyle(
                              height: 2,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                              fontSize: 17)),
                    ],
                  ),
                )
              : Container(),
          (decodedMessageData.containsKey('budget') &&
                  decodedMessageData['budget'].toString().isNotEmpty)
              ? RichText(
                  text: TextSpan(
                    text: 'Budget: ',
                    style: const TextStyle(
                        height: 2, color: blackColor, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text: decodedMessageData['budget'].toString(),
                          style: const TextStyle(
                              height: 2,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                              fontSize: 17)),
                    ],
                  ),
                )
              : Container(),
          const Divider(),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (decodedMessageData.containsKey('message_ar') &&
                    decodedMessageData['message_ar'].toString().isNotEmpty)
                ? Text(
                    decodedMessageData['message_ar'].toString(),
                    style: const TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                        fontSize: 17),
                  )
                : const SizedBox.shrink(),
            RichText(
              text: TextSpan(
                text: '$lblRequestLocationAr: ',
                style:
                    const TextStyle(height: 2, color: blackColor, fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                      text: decodedMessageData['location_ar'].toString(),
                      style: const TextStyle(
                          height: 2,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                          fontSize: 17)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '$lblRequestBudgetAr: ',
                style:
                    const TextStyle(height: 2, color: blackColor, fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                      text: decodedMessageData['budget_ar'].toString(),
                      style: const TextStyle(
                          height: 2,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                          fontSize: 17)),
                ],
              ),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (decodedMessageData['contactType'].toString().contains('1'))
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: TextIconButton(
                        title: 'my_request.Call'.tr(),
                        iconData: contactUsIcon,
                        titleSize: textSmallSize,
                        iconSize: pageTitleSize,
                        titleColor: lightColor,
                        iconColor: lightColor,
                        buttonColor: primaryColor,
                        borderColor: primaryDark,
                        radius: unitWidth * 5,
                        itemSpace: unitWidth,
                        onPressed: () {
                          String phone = "+${decodedMessageData['phone']}";
                          phone = phone.replaceAll(' ', '');
                          launchUrl(Uri.parse("tel:$phone"));
                        },
                      ),
                    )
                  : Container(),
              (decodedMessageData['contactType'].toString().contains('2'))
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: TextIconButton(
                        title: 'my_request.Whatsapp'.tr(),
                        iconData: wpIcon,
                        titleSize: textSmallSize,
                        iconSize: pageTitleSize,
                        titleColor: lightColor,
                        iconColor: lightColor,
                        buttonColor: primaryColor,
                        borderColor: primaryDark,
                        radius: unitWidth * 5,
                        itemSpace: unitWidth,
                        onPressed: () {
                          _launchWhatsapp(
                              decodedMessageData['phone'].toString(), 'Hello');
                        },
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

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
}
