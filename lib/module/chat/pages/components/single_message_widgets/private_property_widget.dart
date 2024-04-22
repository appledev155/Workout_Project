import 'dart:convert';

import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_colors.dart';
import '../../../../../config/styles.dart';
import '../../../../../views/components/property_row/price.dart';
import '../image_slider_screen.dart';

class PrivatePropertyWidget extends StatelessWidget {
  final String privateProperty;
  final String appUserId;
  const PrivatePropertyWidget(
      {super.key, required this.privateProperty, required this.appUserId});

  @override
  Widget build(BuildContext context) {
    Message decodedMessage = Message.fromJson(jsonDecode(privateProperty));

    MessageContent messageContent =
        MessageContent.fromJson(jsonDecode(decodedMessage.content.toString()));

    dynamic decodedMessageData =
        (messageContent.data.runtimeType.toString() == '_Map<String, dynamic>')
            ? messageContent.data
            : jsonDecode(messageContent.data);
    dynamic mediaAssets = [];
    final String gifPath = dotenv.env['GifPath'].toString();
    if (decodedMessageData['propertyImage'].isNotEmpty) {
      mediaAssets = jsonDecode(decodedMessageData['propertyImage']);
    }

    return GestureDetector(
      onTap: () {
        showPrivatePropertyDetails(context, mediaAssets, decodedMessageData);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          color: lightColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (mediaAssets != null && mediaAssets.length > 0)
                ? CachedNetworkImage(
                    imageUrl: mediaAssets.first["result"]["resize_image"]
                        ["media_url"],
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.network(
                          '$gifPath/assets/static/giphy.gif',
                          height: 150.0,
                          width: 150.0,
                        ),
                    errorWidget: (context, url, error) {
                      return Container();
                    })
                : Container(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (decodedMessageData['price'].isNotEmpty)
                      ? Price(price: decodedMessageData['price'].toString())
                      : Container(),
                  (decodedMessageData['propertyTitle'].isNotEmpty)
                      ? Text(
                          decodedMessageData['propertyTitle'].toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(
                            fontFamily: 'DM Sans',
                            forceStrutHeight:
                                (context.locale.toString() == 'ar_AR')
                                    ? true
                                    : false,
                          ),
                          style: TextStyle(
                            color: primaryDark,
                            fontSize: pageTitleSize,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                  (decodedMessageData['propertyDescription'].isNotEmpty)
                      ? Text(
                          decodedMessageData['propertyDescription'].toString(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              height: 2, color: blackColor, fontSize: 14),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPrivatePropertyDetails(
    BuildContext context,
    dynamic propertyImages,
    decodedMessageData,
  ) async {
    await showModalBottomSheet<dynamic>(
        backgroundColor: lightColor,
        context: context,
        elevation: 3.0,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setStateSB) => Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "propertyDetails.lbl_property_details".tr(),
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: blackColor),
                            ),
                          ),
                          (propertyImages != null)
                              ? Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ImageSliderScreen(
                                      imageArray: propertyImages))
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  decodedMessageData['propertyTitle']
                                      .toString(),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(
                                    fontFamily: 'DM Sans',
                                    forceStrutHeight:
                                        (context.locale.toString() == 'ar_AR')
                                            ? true
                                            : false,
                                  ),
                                  style: TextStyle(
                                    color: primaryDark,
                                    fontSize: pageTitleSize + 3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(
                                  thickness: 2.0,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "propertyDetails.lbl_property_price : "
                                            .tr(),
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Price(
                                          price: decodedMessageData['price']
                                              .toString()),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 2.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "propertyDetails.lbl_about_property".tr(),
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      decodedMessageData['propertyDescription']
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          height: 2,
                                          color: blackColor,
                                          fontSize: 17.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
        });
  }
}
