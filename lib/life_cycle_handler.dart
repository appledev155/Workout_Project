import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class LifecycleEventHandler extends WidgetsBindingObserver {
  detachedCallBack() async {
    app_instance.appConfig.resetBatchCountCalled = false;
    final unreadPrivateChannelCount =
        await app_instance.storage.read(key: 'unreadPrivateChannelCount');
    Fluttertoast.cancel();
    app_instance.appConfig.displayToastMessage = false;
    // final checkInternet = await app_instance.connectivity.checkConnectivity();
    if (unreadPrivateChannelCount != null &&
        unreadPrivateChannelCount.isNotEmpty) {
      if (app_instance.appConfig.detachedEventCalled == false) {
        app_instance.appConfig.detachedEventCalled = true;
        app_instance.userRepository.storeUserLastVisitedTime(
            unreadPrivateChannelCount: unreadPrivateChannelCount.toString());
      }
    }
  }

  resumeCallBack() {
    app_instance.appConfig.displayToastMessage = true;
    app_instance.appConfig.detachedEventCalled = false;
    // final checkInternet = await app_instance.connectivity.checkConnectivity();
    if (app_instance.appConfig.resetBatchCountCalled == false) {
      app_instance.appConfig.resetBatchCountCalled = true;
      app_instance.userRepository.storeUserVisitedTime();
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        resumeCallBack();
        break;
    }
  }
}
