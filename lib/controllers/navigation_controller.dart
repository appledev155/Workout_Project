import 'package:flutter/material.dart';

class NavigationController {
  GlobalKey<NavigatorState>? navigationKey = GlobalKey<NavigatorState>();

  static NavigationController instance = NavigationController();

  Future<dynamic> pushReplacementNamed(String rn) {
    return navigationKey!.currentState!.pushReplacementNamed(rn);
  }

  Future<dynamic> pushNamed(String rn, {Object? arguments}) {
    return navigationKey!.currentState!.pushNamed(rn, arguments: arguments);
  }

  Future<dynamic> push(MaterialPageRoute rn) {
    return navigationKey!.currentState!.push(rn);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String rn) {
    return navigationKey!.currentState!
        .pushNamedAndRemoveUntil(rn, (Route<dynamic> route) => false);
  }

  Future<dynamic> popAndPushNamed(String rn) {
    return navigationKey!.currentState!.popAndPushNamed(rn);
  }

  pop() {
    return navigationKey!.currentState!.pop();
  }
}
