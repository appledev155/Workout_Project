import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PropertyType extends StatelessWidget {
  final String? propertyTypeConst;
  const PropertyType({Key? key, this.propertyTypeConst})
      : assert(propertyTypeConst != ''),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      'DATABASE_VAR.$propertyTypeConst',
      strutStyle: StrutStyle(
        fontFamily: 'DM Sans',
        forceStrutHeight: (context.locale.toString() == 'ar_AR') ? true : false,
      ),
      style: TextStyle(
        color: greyColor,
        fontSize: pageIconSize,
      ),
    ).tr();
  }
}
