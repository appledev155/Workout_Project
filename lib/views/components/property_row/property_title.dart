import '../../../model/item_model.dart';
import '../../../config/styles.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PropertyTitle extends StatelessWidget {
  final String? propertyTitle;
  final String? propertyTitleAr;
  final ItemModel? item;

  PropertyTitle({Key? key, this.propertyTitle, this.propertyTitleAr, this.item})
      : assert(propertyTitle.toString() != ''),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    String rec;
    rec = (propertyTitle != null || propertyTitleAr != null)
        ? (context.locale.toString() == 'ar_AR')
            ? ((propertyTitleAr != null) ? propertyTitleAr! : propertyTitle!)
            : ((propertyTitle != null) ? propertyTitle! : propertyTitleAr!)
        : '';
    return Text(
      rec,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyle(
        fontFamily: 'DM Sans',
        forceStrutHeight: (context.locale.toString() == 'ar_AR') ? true : false,
      ),
      style: TextStyle(
        color: primaryDark,
        fontSize: pageTitleSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
