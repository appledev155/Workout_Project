import 'dart:convert';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class CustomUrlWebview extends StatefulWidget {
  final String htmlString;
  final String url;
  final dynamic metaData;
  const CustomUrlWebview(
      {super.key,
      required this.htmlString,
      required this.url,
      required this.metaData});

  @override
  State<CustomUrlWebview> createState() => _CustomUrlWebviewState();
}

class _CustomUrlWebviewState extends State<CustomUrlWebview> {
  @override
  void initState() {
    super.initState();
  }

  double webViewHeight = 1000;
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    String htmlData =
        '''<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width, viewport-fit=cover">${widget.htmlString}''';
    return Wrap(
      children: [
        (widget.metaData['medium'] != "video")
            ? Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                      ),
                      onPressed: () {
                        app_instance.utility.launchURL(widget.url);
                      },
                      child: const Text("chat_section.lbl_visit_site").tr()),
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(
          height: (widget.htmlString.contains("max-width: 56vh") == true &&
                  widget.metaData['medium'] == "video")
              ? MediaQuery.of(context).size.height * 0.85
              : (widget.metaData['medium'] == "video")
                  ? MediaQuery.of(context).size.height * 0.30
                  : MediaQuery.of(context).size.height * 0.85,
          child: SizedBox(
            height: webViewHeight,
            width: double.infinity,
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..getScrollPosition()
                ..setNavigationDelegate(NavigationDelegate(
                  onProgress: (int progress) {},
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) {},
                ))
                ..loadRequest(
                  Uri.dataFromString(
                    htmlData,
                    mimeType: 'text/html',
                  ),
                )
                ..addJavaScriptChannel(
                  'iframly-${widget.url}',
                  onMessageReceived: (message) async {
                    Map<String, dynamic> dimensions =
                        jsonDecode(message.message);
                    setState(() {
                      webViewHeight = 6000;
                    });
                  },
                ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
