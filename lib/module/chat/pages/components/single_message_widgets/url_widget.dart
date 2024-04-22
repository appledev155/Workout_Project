import 'dart:convert';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/custom_url_webview.dart';
import 'package:anytimeworkout/module/chat/pages/components/single_message_widgets/insta_twitter_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class UrlWidget extends StatefulWidget {
  final MessageRow messageRow;
  final String appUserId;
  final int maxLines;

  const UrlWidget(
      {super.key,
      required this.messageRow,
      required this.appUserId,
      this.maxLines = 10});

  @override
  State<UrlWidget> createState() => _UrlWidgetState();
}

class _UrlWidgetState extends State<UrlWidget> {
  @override
  Widget build(BuildContext context) {
    MessageContent? messageContent = widget.messageRow.message.content;
    dynamic decodedMessageData = jsonDecode(messageContent!.data);
    dynamic metaData = decodedMessageData['meta'];
    final String gifPath = dotenv.env['GifPath'].toString();
    bool validURL =
        Uri.parse(decodedMessageData['image'].toString()).isAbsolute;
    print("here----------------------------");
    // print("Message Row is --------------${widget.messageRow}");
    print("meta data-----${metaData.runtimeType}-------$metaData");

    return GestureDetector(
      onTap: () {
        if (decodedMessageData['html'] != null) {
          showVideoPopup(
              decodedMessageData['html'], decodedMessageData['url'], metaData);
        } else {
          app_instance.utility.launchURL(decodedMessageData['text'] ?? "");
        }
      },
      child: metaData.runtimeType == Null
          ? Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 23, top: 10),
              child: Text(
                (decodedMessageData['text'].runtimeType != Null)
                    ? decodedMessageData['text']
                    : "",
                style: TextStyle(color: blackColor, fontSize: pageTitleSize),
              ),
            )
          : Center(
              child: Container(
                color: lightGreyColor,
                child: (decodedMessageData['html'].runtimeType == Null)
                    ? Text(
                        decodedMessageData['text'],
                        style: const TextStyle(color: primaryColor),
                      )
                    : (metaData.runtimeType != String &&
                            metaData.containsKey('site') &&
                            metaData['site'] != null &&
                            (metaData['site'] == "Instagram" ||
                                metaData['site'] == "Twitter"))
                        ? InstaTwitterWebView(
                            messageData: decodedMessageData, metaData: metaData)
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (validURL != true)
                                    ? (decodedMessageData['siteIcon'] == "" &&
                                            decodedMessageData['image'] == "" &&
                                            metaData['medium'] == "video")
                                        ? Container(
                                            height: 110.0,
                                            width: double.infinity,
                                            color: lightGreyColor,
                                            child: const Icon(playIcon,
                                                size: 100, color: primaryDark))
                                        : (metaData['site'] != null &&
                                                (metaData['site'] == "Twitter" ||
                                                    metaData['site'] ==
                                                        "Google"))
                                            ? (metaData['site'] == "Twitter")
                                                ? Image.asset(
                                                    "assets/icon/twitter.png")
                                                : Center(
                                                    child: Image.asset(
                                                        "assets/icon/google.png"),
                                                  )
                                            : (decodedMessageData.containsKey(
                                                        "thumbnail") &&
                                                    decodedMessageData[
                                                            'thumbnail'] !=
                                                        "" &&
                                                    decodedMessageData['thumbnail']
                                                        .isNotEmpty)
                                                ? Container(
                                                    width: double.infinity,
                                                    color: lightGreyColor,
                                                    child: CachedNetworkImage(
                                                        fit: BoxFit.fill,
                                                        imageUrl:
                                                            decodedMessageData[
                                                                    'thumbnail']
                                                                .toString()),
                                                  )
                                                : const SizedBox.shrink()
                                    : (metaData['site'] != null &&
                                            (metaData['site'] == "Instagram" ||
                                                metaData['site'] == "Google"))
                                        ? (metaData['site'] == "Instagram")
                                            ? Image.asset(
                                                "assets/icon/insta.png",
                                                height: 90,
                                                width: 90)
                                            : Center(
                                                child: Image.asset(
                                                    "assets/icon/google.png",
                                                    height: 90,
                                                    width: 90),
                                              )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                decodedMessageData['thumbnail']
                                                    .toString(),
                                            height: 200.0,
                                            width: double.infinity,
                                            placeholder: (context, url) =>
                                                Image.network(
                                                  '$gifPath/assets/static/giphy.gif',
                                                  height: 150.0,
                                                  width: 150.0,
                                                ),
                                            errorWidget: (context, url, error) {
                                              return Container();
                                            }),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  color: lightGreyColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (metaData['title'].runtimeType != Null)
                                          ? Text(
                                              metaData['title'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: linkTitleSize,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(height: 5),
                                      (metaData['description'].runtimeType !=
                                              Null)
                                          ? Text(metaData['description'] ?? "",
                                              maxLines: widget.maxLines,
                                              style: TextStyle(fontSize: 20.sp),
                                              overflow: TextOverflow.ellipsis)
                                          : const SizedBox.shrink(),
                                      const SizedBox(height: 5),
                                      Wrap(
                                        children: [
                                          Text(
                                            decodedMessageData['url'] ?? "",
                                            style: TextStyle(
                                                color: primaryDark,
                                                fontSize: 17.sp),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                (decodedMessageData.containsKey('text') &&
                                        decodedMessageData.containsKey('url'))
                                    ? (decodedMessageData['text'] ==
                                            decodedMessageData['url'])
                                        ? const SizedBox.shrink()
                                        : Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${decodedMessageData['text']}",
                                              style: TextStyle(
                                                  height: 2,
                                                  color: blackColor,
                                                  fontSize: 18.sp),
                                            ),
                                          )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
              ),
            ),
    );
  }

  dynamic showVideoPopup(String htmlString, String url, dynamic metaData) {
    return showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: lightColor,
      isScrollControlled: (htmlString.contains("max-width: 56vh") == true &&
              metaData['medium'] == "video")
          ? true
          : (metaData['medium'] == "video")
              ? false
              : true,
      builder: (context) {
        return SingleChildScrollView(
          child: CustomUrlWebview(
              htmlString: htmlString, url: url, metaData: metaData),
        );
      },
    );
  }
}
