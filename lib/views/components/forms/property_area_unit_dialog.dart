import 'package:anytimeworkout/config/styles.dart';

import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_text_button.dart';

enum PropertyAreaUnitEnum { foot, meter }

class PropertyAreaUnitDialog extends StatefulWidget {
  /// filter page style class

  /// completion status dialog width
  final double? width;

  /// completion status dialog height
  final double? height;

  /// completion status dialog border radius
  final double? radius;

  final double? unitWidth;

  /// value
  final String? value;

  PropertyAreaUnitDialog({
    this.width,
    this.height,
    this.unitWidth,
    this.radius = 0,
    this.value,
  })  : assert(width != null),
        assert(height != null);

  @override
  _PropertyAreaUnitDialogState createState() => _PropertyAreaUnitDialogState();
}

class _PropertyAreaUnitDialogState extends State<PropertyAreaUnitDialog> {
  PropertyAreaUnitEnum? unit;
  String? value;

  bool rec = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      value = widget.value;
      unit = value == 'Sq. Ft.'
          ? PropertyAreaUnitEnum.foot
          : PropertyAreaUnitEnum.meter;
      rec = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: widget.width!,
      ),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: widget.unitWidth! * 40,
              padding: EdgeInsets.only(
                left: widget.unitWidth! * 10,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: greyColor.withOpacity(0.4)),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'location.lbl_area'.tr(),
                style: TextStyle(
                    color: darkColor,
                    fontSize: pageIconSize * 1.2,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.unitWidth! * 15,
              ),
              height: widget.unitWidth! * 55,
              alignment: Alignment.centerLeft,
              child: RadioListTile(
                activeColor: primaryDark,
                value: PropertyAreaUnitEnum.foot,
                groupValue: unit,
                title: Text(
                  'addproperty.lbl_sqft'.tr(),
                  style: TextStyle(
                    color: darkColor,
                    fontSize: pageTextSize * 1.1,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    unit = value as PropertyAreaUnitEnum?;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.unitWidth! * 15,
              ),
              height: widget.unitWidth! * 55,
              alignment: Alignment.centerLeft,
              child: RadioListTile(
                activeColor: primaryDark,
                value: PropertyAreaUnitEnum.meter,
                groupValue: unit,
                title: Text(
                  'addproperty.lbl_sqm'.tr(),
                  style: TextStyle(
                    color: darkColor,
                    fontSize: pageTextSize * 1.1,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    unit = value as PropertyAreaUnitEnum?;
                  });
                },
              ),
            ),
            Container(
              height: unitWidth * 55,
              padding: EdgeInsets.symmetric(horizontal: pageHPadding * 1.8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: greyColor.withOpacity(0.4)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: CustomTextButton(
                    title: 'filter.lbl_canceltext'.tr(),
                    titleSize: pageTextSize * 1.1,
                    titleColor: primaryDark,
                    buttonColor: lightColor,
                    borderColor: primaryDark,
                    onPressed: () => Navigator.pop(context),
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: CustomTextButton(
                    title: 'filter.lbl_oktext'.tr(),
                    titleSize: pageTextSize * 1.1,
                    titleColor: lightColor,
                    buttonColor: primaryDark,
                    borderColor: primaryDark,
                    onPressed: () => Navigator.pop(
                      context,
                      unit == PropertyAreaUnitEnum.foot ? 'Sq. Ft.' : 'Sq. M.',
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
