import 'package:anytimeworkout/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

class TextBox extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? inputValue;
  final String? errorText, jobTitle;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obsecureText;
  final Widget? suffixIcon, prefixIcon;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool readOnly;
  final void Function()? onTap;
  final String? initialValue;
  final AutovalidateMode? autovalidateMode;
  final int? maxLength;
  const TextBox(
      {Key? key,
      this.controller,
      this.label,
      this.jobTitle,
      this.inputValue,
      this.onChanged,
      this.errorText,
      this.validator,
      this.suffixIcon,
      this.prefixIcon,
      this.initialValue,
      this.keyboardType,
      this.autofillHints,
      this.inputFormatters,
      this.obsecureText = false,
      this.maxLines = 1,
      this.readOnly = false,
      this.onTap,
      this.autovalidateMode,
      this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.inter(
                color: blackColor, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          )
        ],
        TextFormField(
          controller: controller,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          onTap: onTap, maxLength: maxLength,
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obsecureText,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          initialValue: initialValue,
          textInputAction: TextInputAction.go,
          //title: jobTitle,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            fillColor: lightColor,
            filled: true,
            errorText: errorText,
            hintText: inputValue!,
            hintStyle: GoogleFonts.inter(color: greyColor, fontSize: 15),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: lightColor),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: lightColor),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: lightColor),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }
}
