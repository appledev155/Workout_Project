

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/activities_pages.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/challenges.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/clubs.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/data_permissions.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/events.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/friends.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/other.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/styles.dart';

class PushNotificationPage extends StatefulWidget {
  const PushNotificationPage({super.key});

  @override
  State<PushNotificationPage> createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:  Text(
          'Push Notification',
          style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: pageTitleSize,
                        color: lightColor),
        ),
         systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: lightColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ActivityPage(),
              FriendsPage(),
              ChallengesPage(),
              ClubsPage(),
              Eventpage(),
              PostPage(),
              DataPermissionPage(),
              OtherPage()
            ],
          ),
        ),
      ),
    );
  }
}
