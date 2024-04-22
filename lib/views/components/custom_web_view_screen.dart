import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class CustomWebViewScreen extends StatefulWidget {
   final String? title;
  const CustomWebViewScreen({super.key, this.title, });

  @override
  _CustomWebViewScreenState createState() => _CustomWebViewScreenState();
}

class _CustomWebViewScreenState extends State<CustomWebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.title.toString(),
            style: const TextStyle(color: blackColor),
          ).tr(),
          elevation: 1,
          centerTitle: true,
          backgroundColor: lightColor,
          iconTheme: const IconThemeData(color: blackColor),
          leading: IconButton(
            icon: Icon(
              (context.locale.toString() == 'en_US')
                  ? iosBackButton
                  : iosForwardButton,
            ),
            onPressed: () => Navigator.pop(context),
          )),
      body:Container(
        child: const Center(child: Text("Privacy policy page")),
      )
      //  WebViewWidget(
      //   controller: WebViewController()
      //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //     ..loadRequest(
      //       Uri.parse(widget.html!),
      //     ),
      // ),
    );
  }
}
