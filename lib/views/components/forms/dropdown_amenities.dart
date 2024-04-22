import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DropdownAmenities extends StatelessWidget {
  /// width of dropdown
  final double? width;

  /// height of dropdown
  final double? height;

  /// radius of dropdown border
  final double? radius;

  /// horizontal padding of children
  final double? hPadding;

  /// label string
  final String? label;

  /// hint string
  final String? hint;

  /// prefix icon data
  final IconData? prefixIcon;

  /// suffix icon data
  final IconData? suffixIcon;

  /// value of dropdown
  final String? value;

  final int? stateValue;

  /// label color
  final Color? labelColor;

  /// hint color
  final Color? hintColor;

  /// prefix icon color
  final Color? prefixIconColor;

  /// suffix icon color
  final Color? suffixIconColor;

  /// border color
  final Color? borderColor;

  /// font color of value string
  final Color? fontColor;

  /// font size
  final double? fontSize;

  /// icon size
  final double? iconSize;

  /// onTap function
  final Function()? onTap;

  DropdownAmenities({
    this.width,
    this.height,
    this.radius = 0,
    this.hPadding = 0,
    this.label = 'label',
    this.hint = 'hint',
    this.prefixIcon,
    this.suffixIcon = Icons.arrow_drop_down,
    this.value,
    this.stateValue,
    this.labelColor,
    this.hintColor,
    this.prefixIconColor,
    this.suffixIconColor,
    this.borderColor,
    this.fontColor,
    this.fontSize,
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: hPadding!),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!),
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              prefixIcon != null
                  ? Icon(prefixIcon, color: prefixIconColor, size: iconSize)
                  : SizedBox.shrink(),
              SizedBox(width: prefixIcon != null ? 10 : 0),
              Text(
                label!,
                style: TextStyle(color: labelColor, fontSize: fontSize),
              ),
              Expanded(
                  child: Text(
                value.toString() != null && value.toString() != ''
                    ? value.toString()
                    : hint!,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value != null && value != '' ? fontColor : hintColor,
                  fontSize: fontSize,
                ),
              ).tr()),
              Icon(suffixIcon, color: suffixIconColor, size: iconSize),
            ],
          ),
        ),
      ),
    );
  }
}
