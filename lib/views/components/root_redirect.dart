import '../../config/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import "dart:async";

class RootRedirect {
  static void successMsg(context, msg, root) async {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        backgroundColor: activeColor,
        textColor: lightColor);

    if (root != '') {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (root == 'pop') {
        Navigator.pop(context);
      } else if (root == 'clearBack') {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/search_result', (Route<dynamic> route) => false);
      } else if (root == 'verified2' || root == 'verified3') {
        Navigator.pop(context);
        // Navigator.pop(context);
        if (root == 'verified3') Navigator.pop(context);
      } else {
        Navigator.popAndPushNamed(context, root);
      }
    }
  }
}
