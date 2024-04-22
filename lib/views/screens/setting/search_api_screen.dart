import 'dart:io';
import 'package:anytimeworkout/config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:flutter/material.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class SearchApiScreen extends StatefulWidget {
  @override
  _SearchApiScreenState createState() => _SearchApiScreenState();
}

class _SearchApiScreenState extends State<SearchApiScreen> {
  int apiSelection = 0;
  final apiList = {
    0: 'Laravel - PHP',
    1: 'Laravel - Algolia',
    2: 'Algolia Rest'
  };

  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    apiSelection = int.tryParse(
        await app_instance.storage.read(key: 'searchType') ?? '0')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightColor,
          elevation: 1,
          title: const Text(
            'settings.lbl_search_api',
            style: TextStyle(color: blackColor),
          ).tr(),
          centerTitle: true,
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
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
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          iconTheme: const IconThemeData(color: blackColor),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'settings.lbl_choose_api',
              style: TextStyle(color: blackColor, fontSize: pageTitleSize),
            ).tr(),
            const SizedBox(
              height: 10,
            ),
            ...apiList.entries
                .map((e) => RadioListTile(
                    value: e.key,
                    groupValue: apiSelection,
                    title: Text(
                      e.value,
                      style: const TextStyle(color: blackColor),
                    ),
                    onChanged: (e) async {
                      apiSelection = int.parse(e.toString());
                      await app_instance.storage
                          .write(key: 'searchType', value: e.toString());
                      setState(() {});
                    }))
                .toList()
          ]),
        ),
      ),
    );
  }
}
