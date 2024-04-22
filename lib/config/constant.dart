import 'dart:async';

import 'package:flutter/cupertino.dart';

class Constants {
  // ignore: close_sinks
  static final StreamController<int> refresh = StreamController.broadcast();

  // ignore: close_sinks
  static final StreamController<int> refreshMyRequestScreen =
      StreamController.broadcast();
  // ignore: close_sinks
  static final StreamController<int> channel = StreamController.broadcast();
  // ignore: close_sinks
  static final StreamController<String> isFailed = StreamController.broadcast();

  static final ValueNotifier<String> counter = ValueNotifier<String>('');
  static final ValueNotifier<int> countAgent = ValueNotifier<int>(0);
  static final ValueNotifier<Set<String>> channelList =
      ValueNotifier<Set<String>>({});

  static final ValueNotifier<List<dynamic>> historyList =
      ValueNotifier<List<dynamic>>([]);

  static final ValueNotifier<bool> isSelected = ValueNotifier<bool>(false);
  bool isResultCalled = false;

  final int secondsRemaining = 78;

  final int automaticCallSeconds = 115;
}
