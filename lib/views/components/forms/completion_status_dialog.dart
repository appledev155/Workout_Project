import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../views/components/forms/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum CompletionStatusEnum { offPlan, ready }

class CompletionStatusDialog extends StatefulWidget {
  /// completion status dialog width
  final double? width;

  /// completion status dialog height
  final double? height;

  /// completion status dialog border radius
  final double? radius;

  /// value
  final String? value;

  final int? stateValue;

  CompletionStatusDialog({
    this.width,
    this.height,
    this.radius = 0,
    this.value,
    this.stateValue,
  })  : assert(width != null),
        assert(height != null);

  @override
  _CompletionStatusDialogState createState() => _CompletionStatusDialogState();
}

class _CompletionStatusDialogState extends State<CompletionStatusDialog> {
  String? value;
  int? stateValue;
  CompletionStatusEnum? status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      value = widget.value;
      stateValue = widget.stateValue;
      status = stateValue == 1
          ? CompletionStatusEnum.ready
          : CompletionStatusEnum.offPlan;
      if (stateValue == 2) status = null;
      if (stateValue == null) status = null;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: widget.width!,
      ),
      backgroundColor: Colors.transparent,
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
                  bottom: BorderSide(color: greyColor.withOpacity(0.6)),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'addproperty.lbl_property_status',
                style: TextStyle(
                    color: darkColor,
                    fontSize: pageIconSize * 1.2,
                    fontWeight: FontWeight.w500),
              ).tr(),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: unitWidth * 15,
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: greyColor.withOpacity(0.4)),
                ),
              ),
              child: RadioListTile(
                value: CompletionStatusEnum.offPlan,
                activeColor: primaryDark,
                groupValue: status,
                title: Text(
                  'addproperty.lbl_under_construnction',
                  style: TextStyle(
                    color: darkColor,
                    fontSize: pageTitleSize,
                  ),
                ).tr(),
                subtitle: Padding(
                  padding: EdgeInsets.only(
                    top: unitWidth * 10,
                  ),
                  child: Text(
                    'addproperty.lbl_ready_to_move_in_text',
                    style: TextStyle(
                      color: darkColor,
                      fontSize: pageSmallIconSize,
                    ),
                  ).tr(),
                ),
                onChanged: (value) {
                  setState(() {
                    status = value! as CompletionStatusEnum?;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: unitWidth * 15,
              ),
              alignment: Alignment.centerLeft,
              child: RadioListTile(
                activeColor: primaryDark,
                value: CompletionStatusEnum.ready,
                groupValue: status,
                title: Text(
                  'addproperty.lbl_ready_to_move_in',
                  style: TextStyle(
                    color: darkColor,
                    fontSize: pageTitleSize,
                  ),
                ).tr(),
                subtitle: Padding(
                  padding: EdgeInsets.only(
                    top: unitWidth * 10,
                  ),
                  child: Text(
                    'addproperty.lbl_under_construnction_in_text',
                    style: TextStyle(
                      color: darkColor,
                      fontSize: pageSmallIconSize,
                    ),
                  ).tr(),
                ),
                onChanged: (value) {
                  setState(() {
                    status = value as CompletionStatusEnum?;
                  });
                },
              ),
            ),
            Container(
              height: unitWidth * 55,
              padding: EdgeInsets.symmetric(horizontal: pageHPadding * 1.8),
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
                    onPressed: () {
                      if (status != null) {
                        Navigator.pop(
                          context,
                          [
                            status == CompletionStatusEnum.ready ? 1 : 0,
                            status == CompletionStatusEnum.ready
                                ? 'addproperty.lbl_ready_to_move_in'
                                : 'addproperty.lbl_under_construnction'
                          ],
                        );
                      } else {
                        Navigator.pop(
                          context,
                          [null, ''],
                        );
                      }
                    },
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
