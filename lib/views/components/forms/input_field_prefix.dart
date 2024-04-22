import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';

class InputFieldPrefix extends StatelessWidget {
  /// textediting controller
  final TextEditingController? controller;

  /// input max height
  final double? height;

  /// input max width
  final double? width;

  /// border color
  final Color? borderColor;

  /// border radius
  final double? radius;

  /// font size of input
  final double? fontSize;

  /// font color of input
  final Color? fontColor;

  /// hint text string
  final String? hint;

  /// hint text color
  final Color? hintColor;

  /// hint text size
  final double? hintSize;

  /// label text string
  final String? label;

  /// label text color
  final Color? labelColor;

  /// label text size
  final double? labelSize;

  /// prefix icon data
  final IconData? prefixIcon;

  /// prefix icon color
  final Color? prefixIconColor;

  /// prefix icon size
  final double? prefixIconSize;

  ///suffix text
  final String? suffixText;

  /// read-only
  final bool? readOnly;

  /// ontap function on input
  final Function()? onTap;

  /// the trigger event on complete the editing
  // final Function()? onEditingComplete;

  /// the tirgger event on submitted the field value
  final Function(String)? onFieldSubmitted;

  /// text input action
  final TextInputAction? textInputAction;

  /// trigger the event when change in input
  final Function(String value)? onChanged;

  /// keyboard type of input field
  final TextInputType? keyboardType;

  final dynamic inputFormatters;

  /// Focus Node
  final FocusNode? focusNode;

  /// space
  final double? space;

  /// obsecure text for password
  final bool? obsecureText;

  /// validator function
  final String? Function(dynamic)? validator;

  /// maxLines
  final int? maxLines;

  InputFieldPrefix({
    required this.height,
    required this.width,
    required this.controller,
    required this.borderColor,
    required this.radius,
    required this.fontSize,
    required this.fontColor,
    required this.hint,
    required this.hintColor,
    required this.hintSize,
    required this.label,
    required this.labelColor,
    required this.labelSize,
    required this.prefixIcon,
    required this.prefixIconSize,
    required this.prefixIconColor,
    this.suffixText = '',
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.space = 0,
    // this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.obsecureText = false,
    this.validator,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label!,
            style: TextStyle(color: labelColor, fontSize: labelSize),
          ),
          SizedBox(height: space),
          TextFormField(
            controller: controller,
            style: TextStyle(color: fontColor, fontSize: fontSize),
            onTap: onTap,
            //onEditingComplete: onEditingComplete!,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              suffixText: suffixText,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: height!,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius!)),
                borderSide: BorderSide(
                  color: borderColor!,
                  width: 0.8,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius!)),
                borderSide: BorderSide(
                  color: borderColor!,
                  width: 0.8,
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius!)),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 0.8,
                  style: BorderStyle.solid,
                ),
              ),
              hintText: hint,
              hintStyle: TextStyle(color: hintColor, fontSize: hintSize),
              prefixIcon: Icon(
                prefixIcon,
                color: prefixIconColor,
                size: prefixIconSize,
              ),
            ),
            readOnly: readOnly!,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}
