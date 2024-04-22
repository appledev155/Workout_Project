import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

class RentFrequency extends StatelessWidget {
  final String? rentFreq;
  const RentFrequency({super.key, this.rentFreq});

  @override
  Widget build(BuildContext context) {
    String text = '';
    switch (rentFreq) {
      case '0':
        text = 'filter.lbl_price_type_any';
        break;
      case '1':
        text = 'filter.lbl_price_type_daily';
        break;
      case '2':
        text = 'filter.lbl_price_type_weekly';
        break;
      case '3':
        text = 'filter.lbl_price_type_monthly';
        break;
      case '4':
        text = 'filter.lbl_price_type_yearly';
        break;
      default:
    }
    return Text(
      tr(text),
      style: const TextStyle(
          fontFeatures: [FontFeature.subscripts()],
          fontWeight: FontWeight.w500),
    );
  }
}
