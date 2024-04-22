/* import 'dart:async';
import 'package:anytimeworkout/views/screens/my_properties/my_properties_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:anytimeworkout/config/data.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void msgPushNotification(id) async {
  FlutterLocalNotificationsPlugin flipMsg =
      new FlutterLocalNotificationsPlugin();
  var android = new AndroidInitializationSettings('status');
  var iOS = new IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  var settings = new InitializationSettings(android: android, iOS: iOS);
  flipMsg.initialize(settings, onSelectNotification: onSelectMsgNotification);
  await flipMsg
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    '$id',
    'ANYTIME WORKOUT',
    'Property post status',
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker',
    playSound: true,
  );

  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flipMsg.show(1, 'Property posted', 'Images uploaded successfully!',
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

Future onSelectMsgNotification(String payload) async {
  final _storage = FlutterSecureStorage();
  await _storage.write(key: 'resetSearch', value: '1');
  await _storage.write(key: 'myPropUpdated', value: 'true');
  Navigator.push(
      globals.notifykey.currentContext,
      new MaterialPageRoute(
          builder: (context) => MyPropertiesScreen(),
          settings: RouteSettings(name: 'my_properties')));
}
 */
