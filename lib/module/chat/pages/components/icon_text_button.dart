import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  final double? titleSize;
  final double? iconSize;
  final Color? titleColor;
  final Color? iconColor;
  final Color? buttonColor;
  final Color? borderColor;
  final Function()? onPressed;
  final double? radius;
  final double? itemSpace;
  final bool? isLeading;
  final bool? isCenter;
  final double? hPadding;
  final double? vPadding;
  final double? elevation;

  const IconTextButton({
    super.key,
    @required this.title,
    @required this.iconData,
    @required this.titleSize,
    @required this.iconSize,
    @required this.titleColor,
    @required this.iconColor,
    @required this.buttonColor,
    @required this.borderColor,
    @required this.onPressed,
    @required this.itemSpace,
    this.elevation = 0,
    this.radius = 10,
    this.isLeading = true,
    this.isCenter = true,
    this.hPadding = 0,
    this.vPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        icon: Icon(iconData, size: iconSize, color: iconColor),
        onPressed: onPressed!,
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor!, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(radius!)),
          ),
        ),
        label: Text(title!,
            style: TextStyle(
              color: titleColor,
              fontSize: titleSize,
            )));
  }
}
