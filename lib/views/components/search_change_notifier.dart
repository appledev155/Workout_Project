import 'package:flutter/widgets.dart';

class Notifier extends ChangeNotifier {
  String serachCount = '';
  onChangeSerachCount(String newserachCount) {
    serachCount = newserachCount;
    notifyListeners();
  }
}
