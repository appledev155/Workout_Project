import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../views/components/forms/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectBoxStringDialog extends StatefulWidget {
  /// width of dialog
  final double? width;

  /// height of dialog
  final double? height;

  final bool? isValueNumber;

  /// radius of dialog
  final double? radius;

  /// title of dialog
  final String? title;

  /// items
  final List? items;

  /// selected values
  final String? value;

  final int? stateValue;

  const SelectBoxStringDialog({
    super.key,
    this.width,
    this.height,
    this.radius = 0,
    this.title,
    this.items,
    this.value,
    this.isValueNumber = false,
    this.stateValue,
  });

  @override
  _SelectBoxStringDialogState createState() => _SelectBoxStringDialogState();
}

class _SelectBoxStringDialogState extends State<SelectBoxStringDialog> {
  String? value;
  int? stateValue;
  bool? isValueNumber;

  @override
  void initState() {
    super.initState();
    value = widget.value;
    stateValue = widget.stateValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: transparentColor,
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
              height: unitWidth * 40,
              padding: EdgeInsets.only(
                left: unitWidth * 10,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: greyColor.withOpacity(0.4),
                  ),
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
                height: unitWidth * 200,
                padding: EdgeInsets.symmetric(
                  horizontal: unitWidth * 6,
                ),
                alignment: Alignment.center,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: widget.items!.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String val = entry.value;
                    String valText = val;
                    if (!widget.isValueNumber!) valText = val.tr();

                    return RadioListTile(
                      activeColor: primaryDark,
                      title: Text(
                        valText,
                        style: TextStyle(
                          color: darkColor,
                          fontSize: pageTextSize * 1.1,
                        ),
                      ).tr(),
                      value: val,
                      groupValue: value,
                      onChanged: (_value) {
                        setState(() {
                          stateValue = idx;
                          value = val;
                        });
                      },
                    );
                  }).toList(),
                )),
            Container(
              height: unitWidth * 55,
              padding: EdgeInsets.symmetric(horizontal: pageHPadding * 2),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: greyColor.withOpacity(0.4),
                  ),
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
                    onPressed: () =>
                        Navigator.pop(context, [stateValue, value]),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
