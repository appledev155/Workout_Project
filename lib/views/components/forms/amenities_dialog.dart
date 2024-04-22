import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../views/components/forms/amenities_button.dart';
import '../../../views/components/forms/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AmenitiesDialog extends StatefulWidget {
  /// width of dialog
  final double? width;

  /// height of dialog
  final double? height;

  /// radius of dialog
  final double? radius;

  /// title of dialog
  final String? title;

  /// items
  final List? items;

  /// selected values
  final List? values;

  final List? valuesName;

  AmenitiesDialog({
    this.width,
    this.height,
    this.radius = 0,
    this.title,
    this.items,
    this.values,
    this.valuesName,
  });

  @override
  _AmenitiesDialogState createState() => _AmenitiesDialogState();
}

class _AmenitiesDialogState extends State<AmenitiesDialog> {
  List? values;
  List? valuesName;

  @override
  void initState() {
    super.initState();
    values = widget.values;
    valuesName = widget.valuesName;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: transparentColor,
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
              height: unitWidth * 40,
              padding: EdgeInsets.only(left: unitWidth * 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: greyColor.withOpacity(0.6)),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.title!,
                style: TextStyle(
                    color: darkColor,
                    fontSize: pageIconSize * 1.2,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: unitWidth * 360,
              padding: EdgeInsets.symmetric(
                horizontal: unitWidth * 15,
              ),
              alignment: Alignment.center,
              child: AmenitiesButton(
                items: widget.items,
                values: values,
                itemWidth: filterSingleSelectDialogOptionWidth,
                itemHeight: unitWidth * 36,
                itemSpace: unitWidth * 2,
                titleSize: pageTextSize,
                radius: unitWidth * 20,
                selectedColor: primaryDark,
                unSelectedColor: lightColor,
                selectedBorderColor: primaryDark,
                unSelectedBorderColor: darkColor,
                selectedTitleColor: lightColor,
                unSelectedTitleColor: darkColor,
                propertyType: 'amenities',
                //  listStyle: true,
                isVertical: true,
                onTap: (value, valueName) {
                  setState(() {
                    if (values!.isNotEmpty && values!.contains(value)) {
                      values!.remove(value);
                      valuesName!.remove(valueName);
                    } else {
                      values!.add(value);
                      valuesName!.add(valueName);
                    }
                  });
                },
              ),
            ),
            Container(
              height: unitWidth * 55,
              padding: EdgeInsets.symmetric(horizontal: pageHPadding * 2),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: greyColor.withOpacity(0.6)),
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
                  const SizedBox(width: 5),
                  Expanded(
                      child: CustomTextButton(
                    title: 'filter.lbl_oktext'.tr(),
                    titleSize: pageTextSize * 1.1,
                    titleColor: lightColor,
                    buttonColor: primaryDark,
                    borderColor: primaryDark,
                    onPressed: () =>
                        Navigator.pop(context, [values, valuesName]),
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
