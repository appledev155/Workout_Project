// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:strava_clone/src/boot.dart';
// import 'package:strava_clone/src/module/settings_page/pages/settingPage.dart';
// import 'package:strava_clone/src/module/settings_page/subpages/beacon/beacon.dart';
// import 'package:strava_clone/src/module/settings_page/subpages/beacon/beacon_device.dart';
// import 'package:strava_clone/src/module/settings_page/subpages/link_other_device/link.dart';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/settings_page/pages/settingPage.dart';
import 'package:anytimeworkout/module/settings_page/subpages/beacon/beacon.dart';
import 'package:anytimeworkout/module/settings_page/subpages/link_other_device/link.dart';
import 'package:flutter/material.dart';

class OtherServicePage extends StatefulWidget {
  bool? beacon;
  OtherServicePage({super.key, this.beacon});

  @override
  State<OtherServicePage> createState() => _OtherServicePageState();
}

class _OtherServicePageState extends State<OtherServicePage> {
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              if (widget.beacon == true) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BeaconPage()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
              }
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Other Services',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: greyColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Devices',
                    style: TextStyle(color: primaryColor),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/device_image.jpg',
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Connect a device to Strava',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Upload directly to Strava from a third party device',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        color: Colors.black54),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Services',
                    style: TextStyle(fontSize: 13, color: primaryColor),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LinkPage()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite_sharp,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Google Fit',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Connect with Google Fit',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                            Checkbox(value: checkboxValue, onChanged: null)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
