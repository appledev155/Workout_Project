import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class DropDownStatic extends StatelessWidget {
  final double? deviceWidth, pageHPadding, unitWidth;
  final dynamic selectedDropDownValue;
  final Function(String? value)? onChanged;
  final String? label;
  final List? city;
  final bool showLabel;
  final bool showIcon;

  const DropDownStatic({
    super.key,
    this.deviceWidth,
    this.pageHPadding,
    this.selectedDropDownValue,
    this.unitWidth,
    this.onChanged,
    this.label,
    this.city,
    this.showLabel = true,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageHPadding!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (label != null)
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label!,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ).tr())
                : Container(),
            (showIcon != true && label != null)
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            (showLabel == true)
                ? Align(
                    alignment: (context.locale.toString() == "en_US")
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Text(
                      "account_upgrade.lbl_city_label".tr(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                  )
                : const SizedBox.shrink(),
            (showIcon != true)
                ? const SizedBox(height: 10)
                : const SizedBox.shrink(),
            DropdownButtonFormField<String>(
                value: selectedDropDownValue.toString().tr(),
                iconSize: (showIcon) ? 15.0 : 24.0,
                focusColor: lightColor,
                decoration: InputDecoration(
                    prefixIcon: (showIcon == true)
                        ? Icon(
                            locationCityIcon,
                            color: blackColor.withOpacity(0.7),
                            size: 20,
                          )
                        : null,
                    contentPadding: (showIcon == true)
                        ? const EdgeInsets.all(5)
                        : EdgeInsets.all(unitWidth! * 15),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (showIcon == true)
                                ? blackColor.withOpacity(0.6)
                                : greyColor.withOpacity(0.6)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (showIcon == true)
                                ? blackColor.withOpacity(0.6)
                                : greyColor.withOpacity(0.6)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)))),
                items: city!.map((value) {
                  if (selectedDropDownValue.toString() ==
                      value.last.toString()) {
                    app_instance.storage
                        .write(key: 'SelectLocation', value: value.last);
                  }
                  return DropdownMenuItem<String>(
                    value: (value!.last).toString(),
                    child: Text(
                      '${value[1]}',
                      style: TextStyle(
                          color: (showIcon)
                              ? blackColor.withOpacity(0.7)
                              : blackColor),
                    ).tr(),
                  );
                }).toList(),
                isExpanded: true,
                onChanged: onChanged)
          ],
        ));
  }
}
