import 'package:anytimeworkout/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PropertyAbout extends StatelessWidget {
  final String? descriptionArebic;
  final String? descriptionEnglish;

  const PropertyAbout({
    Key? key,
    this.descriptionArebic,
    this.descriptionEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? rec;
    rec = (this.descriptionArebic != '' || this.descriptionEnglish != '')
        ? (context.locale.toString() == 'ar_AR')
            ? ((this.descriptionArebic != '')
                ? this.descriptionArebic
                : this.descriptionEnglish)
            : ((this.descriptionEnglish != '')
                ? this.descriptionEnglish
                : this.descriptionArebic)
        : '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            child: Text(
          'propertyDetails.lbl_about_property',
          style: TextStyle(
            fontSize: pageTitleSize * 1.2,
            fontWeight: FontWeight.w500,
          ),
        ).tr()),
        const SizedBox(
          height: 10,
        ),
        Text(
          rec!,
          style: TextStyle(fontSize: pageIconSize * 1.02),
        ),
      ],
    );
  }
}
