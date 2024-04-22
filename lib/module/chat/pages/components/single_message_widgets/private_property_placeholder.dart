import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";

import "../../../../../config/app_colors.dart";
import "../../../../../config/styles.dart";
import "../../../../../views/components/property_row/price.dart";
import "../../../model/chat_model.dart";

StreamSubscription<String>? _uploadProgressStream;

class PrivatePropertyPlaceholder extends StatelessWidget {
  final MessageRow messageRow;
  final String currentUserId;

  const PrivatePropertyPlaceholder(
      {super.key, required this.messageRow, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    Message decodedMessage = messageRow.message;
    MessageContent messageContent = MessageContent.fromJson(
        jsonDecode(messageRow.message.content.toString()));
    dynamic messageString = messageContent.data;
    dynamic uploadUniqueId = messageString["uniqueId"];
    dynamic mediaAssets = messageString['uploadFiles'].runtimeType != Null ||
            messageString['uploadFiles'] != ''
        ? jsonDecode(messageString['uploadFiles'].toString())
        : [];

    return GestureDetector(
      onTap: () {
        // showPrivatePropertyDetails(context, mediaAssets, messageString);
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
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          File(mediaAssets[0].toString())),
                      // const CircularProgressIndicator(color: lightColor),
                      LoadingAnimationWidget.discreteCircle(
                          key: key,
                          color: lightColor,
                          size: 30,
                          secondRingColor: primaryDark,
                          thirdRingColor: redColor)
                    ],
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (messageString['price'].isNotEmpty)
                      ? Price(price: messageString['price'].toString())
                      : Container(),
                  (messageString['propertyTitle'].isNotEmpty)
                      ? Text(
                          messageString['propertyTitle'].toString(),
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
                  (messageString['propertyDescription'].isNotEmpty)
                      ? Text(
                          messageString['propertyDescription'].toString(),
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
}
