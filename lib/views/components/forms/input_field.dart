import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  /// textediting controller
  final TextEditingController? controller;

  ///input max height
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

  /// read-only
  final bool? readOnly;

  /// ontap function on input
  final Function()? onTap;

  /// the trigger event on complete the editing
  final Function()? onEditingComplete;

  /// the tirgger event on submitted the field value
  final dynamic Function(String)? onFieldSubmitted;

  /// text input action
  final TextInputAction? textInputAction;

  /// keyboard type of input field
  final TextInputType? keyboardType;

  /// Focus Node
  final FocusNode? focusNode;

  /// space
  final double? space;

  /// obsecure text for password
  final bool? obsecureText;

  /// validator function
  final String? Function(String?)? validator;

  /// maxLines
  final int? maxLines;

  final dynamic inputFormatters;

  final Color? focusedColor;

  final bool? bordered;

  final TextAlign? textAlign;

  final dynamic Function(String)? onChanged;

  final FontWeight? fontWeight;

  final bool? enabled;

  final String? prefixText;

  final TextStyle? prefixStyle;

  final Widget? suffixIcon;

  final double? minHeight;

  final double? minWidth;

  final double? errorSize;

  InputField(
      {@required this.height,
      @required this.width,
      @required this.controller,
      @required this.borderColor,
      @required this.radius,
      @required this.fontSize,
      @required this.fontColor,
      @required this.hint,
      @required this.hintColor,
      @required this.hintSize,
      @required this.label,
      @required this.labelColor,
      @required this.labelSize,
      this.readOnly = false,
      this.onTap,
      this.textAlign = TextAlign.start,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onChanged,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.fontWeight,
      this.space = 0,
      this.obsecureText = false,
      @required this.validator,
      this.maxLines,
      this.focusedColor,
      this.enabled,
      this.prefixText = '',
      this.prefixStyle,
      this.bordered = true,
      this.suffixIcon,
      this.minHeight = 0,
      this.minWidth = 0,
      this.inputFormatters,
      this.errorSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (label == '')
              ? Container()
              : Text(
                  label!,
                  style: TextStyle(color: labelColor, fontSize: labelSize),
                ),
          // SizedBox(height: space),
          obsecureText!
              ? TextFormField(
                  enabled: enabled,
                  inputFormatters: inputFormatters,
                  controller: controller,
                  style: TextStyle(color: fontColor, fontSize: fontSize),
                  focusNode: focusNode,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  onFieldSubmitted: onFieldSubmitted,
                  textInputAction: textInputAction,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: errorSize),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: bordered! ? 10 : 0,
                      vertical: height!,
                    ),
                    border: bordered!
                        ? OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radius!)),
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    enabledBorder: bordered!
                        ? OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radius!)),
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    focusedBorder: bordered!
                        ? OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radius!)),
                            borderSide: BorderSide(
                              color: focusedColor ?? primaryColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    hintText: hint,
                    hintStyle: TextStyle(color: hintColor, fontSize: hintSize),
                  ),
                  readOnly: readOnly!,
                  obscureText: obsecureText!,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validator,
                )
              : TextFormField(
                  enabled: enabled,
                  textAlign: textAlign!,
                  inputFormatters: inputFormatters,
                  controller: controller,
                  style: TextStyle(
                      color: fontColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight),
                  focusNode: focusNode,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  onFieldSubmitted: onFieldSubmitted,
                  textInputAction: textInputAction,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: errorSize),
                    prefixText: prefixText,
                    prefixStyle: prefixStyle,
                    suffixIcon: suffixIcon,
                    suffixIconConstraints: BoxConstraints(
                      minHeight: minHeight!,
                      minWidth: minWidth!,
                    ),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: bordered! ? 10 : 0,
                      vertical: height!,
                    ),
                    border: bordered!
                        ? OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radius!)),
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    enabledBorder: bordered!
                        ? OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radius!)),
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    focusedBorder: bordered!
                        ? OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radius!)),
                            borderSide: BorderSide(
                              color: focusedColor ?? primaryColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor!,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    hintText: hint,
                    hintStyle: TextStyle(color: hintColor, fontSize: hintSize),
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
