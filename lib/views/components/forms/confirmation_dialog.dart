import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_text_button.dart';

class ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? bodyText;
  final double? width;
  final double? height;
  final double? pageTextSize;
  final double? pageTitleSize;
  final double? unitWidth;

  const ConfirmationDialog(
      {super.key,
      this.width,
      this.height,
      this.title,
      this.bodyText,
      this.pageTextSize,
      this.pageTitleSize,
      this.unitWidth})
      : assert(width != null),
        assert(height != null),
        assert(title != null),
        assert(bodyText != null);

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: lightColor,
          ),
          width: widget.width,
          height: widget.height,
          child: Column(
            children: <Widget>[
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                height: widget.unitWidth! * 50,
                padding: EdgeInsets.only(left: widget.unitWidth! * 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title!,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: widget.pageTitleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: widget.unitWidth! * 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.bodyText!,
                    style: TextStyle(
                      color: darkColor,
                      fontSize: widget.pageTextSize,
                      height: widget.unitWidth! * 1.2,
                    ),
                  ),
                ),
              ),
              Container(
                width: widget.width,
                height: widget.unitWidth! * 40,
                padding: EdgeInsets.only(right: widget.unitWidth! * 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomTextButton(
                      title: 'filter.lbl_canceltext'.tr(),
                      titleSize: widget.pageTextSize!,
                      titleColor: primaryColor,
                      buttonColor: lightColor,
                      borderColor: lightColor,
                      radius: widget.unitWidth! * 2,
                      onPressed: () => Navigator.pop(context),
                    ),
                    CustomTextButton(
                      title: 'filter.lbl_oktext'.tr(),
                      titleSize: widget.pageTextSize!,
                      titleColor: primaryColor,
                      buttonColor: lightColor,
                      borderColor: lightColor,
                      radius: widget.unitWidth! * 2,
                      onPressed: () => Navigator.pop(context, 'ok'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
