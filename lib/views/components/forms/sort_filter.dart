import 'package:anytimeworkout/config/styles.dart';

import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_text_button.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

enum SortFilterEnum { newest, low_to_high, high_to_low }

class SortFilterDialog extends StatefulWidget {
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

  const SortFilterDialog({
    super.key,
    this.width,
    this.height,
    this.unitWidth,
    this.radius = 0,
    this.value,
  })  : assert(width != null),
        assert(height != null);

  @override
  _SortFilterDialogState createState() => _SortFilterDialogState();
}

class _SortFilterDialogState extends State<SortFilterDialog> {
  String? sort;
  String? value;

  bool? rec = false;
  String? min = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      value = widget.value;
      sort = widget.value;
      min = 'list.lbl_newest'.tr();
      if (sort == 'priceLH') min = 'list.lbl_price_low_to_high'.tr();
      if (sort == 'priceHL') min = 'list.lbl_price_high_to_low'.tr();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: transparentColor,
      child: StatefulBuilder(builder: (context, state) {
        return Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  height: widget.unitWidth! * 50,
                  padding: EdgeInsets.only(
                    left: widget.unitWidth! * 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: greyColor.withOpacity(0.4)),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'list.lb_sorting'.tr(),
                          style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: pageIconSize * 1.2,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          min!,
                          style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: pageIconSize * 1.2,
                          ),
                        )
                      ])),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.unitWidth! * 15,
                ),
                height: widget.unitWidth! * 55,
                alignment: Alignment.centerLeft,
                child: RadioListTile(
                  value: 'newest',
                  groupValue: sort,
                  selected: (sort == 'newest') ? true : false,
                  title: Text(
                    'list.lbl_newest'.tr(),
                    style: TextStyle(
                      color: blackColor,
                      fontSize: pageTextSize,
                    ),
                  ),
                  onChanged: (value) async {
                    state(() {
                      sort = value.toString();
                      min = 'list.lbl_newest'.tr();
                      app_instance.storage.write(key: "sortBy", value: sort);
                    });
                    await app_instance.storage
                        .write(key: "sortBy", value: sort);
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
                  value: 'priceLH',
                  groupValue: sort,
                  selected: (sort == 'priceLH') ? true : false,
                  title: Text(
                    'list.lbl_price_low_to_high'.tr(),
                    style: TextStyle(
                      color: blackColor,
                      fontSize: pageTextSize,
                    ),
                  ),
                  onChanged: (value) async {
                    state(() {
                      sort = value.toString();
                      min = 'list.lbl_price_low_to_high'.tr();
                      app_instance.storage.write(key: "sortBy", value: sort);
                    });
                    await app_instance.storage
                        .write(key: "sortBy", value: sort);
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
                  value: 'priceHL',
                  selected: (sort == 'priceHL') ? true : false,
                  groupValue: sort,
                  title: Text(
                    'list.lbl_price_high_to_low'.tr(),
                    style: TextStyle(
                      color: blackColor,
                      fontSize: pageTextSize,
                    ),
                  ),
                  onChanged: (value) async {
                    state(() {
                      sort = value.toString();
                      min = 'list.lbl_price_high_to_low'.tr();
                    });
                    await app_instance.storage
                        .write(key: "sortBy", value: sort);
                  },
                ),
              ),
              Container(
                height: unitWidth * 55,
                padding: EdgeInsets.symmetric(horizontal: pageHPadding * 2),
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
                            onPressed: () => Navigator.pop(context, sort))),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
