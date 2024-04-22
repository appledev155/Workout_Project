import 'package:anytimeworkout/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Location extends StatelessWidget {
  final String? location;
  final String? locationAr;
  const Location({Key? key, this.location, this.locationAr}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String? rec;
    rec = (context.locale.toString() == 'ar_AR')
        ? ((locationAr != '') ? locationAr : location)
        : ((location != '') ? location : locationAr);
    return Text(
      rec!,
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyle(
        fontFamily: 'DM Sans',
        forceStrutHeight: (context.locale.toString() == 'ar_AR') ? true : false,
      ),
      style: TextStyle(fontSize: pageIconSize),
    );
  }
}
