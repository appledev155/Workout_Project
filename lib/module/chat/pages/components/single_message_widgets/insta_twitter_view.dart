import 'package:anytimeworkout/config/app_colors.dart';
import 'package:flutter/material.dart';

class InstaTwitterWebView extends StatelessWidget {
  final dynamic messageData;
  final dynamic metaData;
  const InstaTwitterWebView(
      {required this.messageData, required this.metaData, super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 0,
        color: lightGreyColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              if (metaData['site'] == "Instagram") ...[
                Expanded(flex: 1, child: Image.asset("assets/icon/insta.png")),
              ],
              if (metaData['site'] == "Twitter") ...[
                Expanded(flex: 1, child: Image.asset("assets/icon/twitter.png"))
              ],
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    metaData['title'],
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    children: [
                      Text(metaData['description'] ?? "", maxLines: 3),
                      Text(messageData['url'] ?? "",
                          maxLines: 2,
                          style: const TextStyle(color: primaryColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
