import 'package:anytimeworkout/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../config/styles.dart';

class ChangeNumber extends StatelessWidget {
  final String? currentNumber;
  final String? hintText;
  const ChangeNumber({super.key, this.currentNumber, this.hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(hintText!,
                style: TextStyle(
                  color: primaryDark,
                  fontWeight: FontWeight.w500,
                  fontSize: pageTitleSize,
                )),
            Text(currentNumber!,
                textDirection: ui.TextDirection.ltr,
                style: TextStyle(
                    color: primaryDark,
                    fontWeight: FontWeight.w500,
                    fontSize: pageTitleSize))
          ]),
    );
  }
}
