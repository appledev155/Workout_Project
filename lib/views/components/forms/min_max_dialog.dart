import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import '../../../views/components/forms/custom_text_button.dart';
import '../../../views/components/forms/radio_select_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MinMaxDialog extends StatefulWidget {
  /// filter page style

  /// dialog width
  final double? width;

  /// dialog height
  final double? height;

  /// items
  final List? items;

  /// min value
  final dynamic minValue;

  /// max value
  final dynamic maxValue;

  /// padding
  final double? padding;

  /// border radius
  final double? radius;

  ///input formatter
  final dynamic inputFormatters;

  const MinMaxDialog(
      {super.key,
      this.width,
      this.height,
      this.items,
      this.minValue,
      this.maxValue,
      this.padding = 10,
      this.radius = 10,
      this.inputFormatters})
      : assert(width != null),
        assert(height != null),
        assert(items != null),
        assert(minValue != null),
        assert(maxValue != null);

  @override
  _MinMaxDialogState createState() => _MinMaxDialogState();
}

class _MinMaxDialogState extends State<MinMaxDialog> {
  TextEditingController? minController = TextEditingController();
  TextEditingController? maxController = TextEditingController();
  bool? val = false;
  var color = greyColor;

  @override
  void initState() {
    super.initState();
    minController!.text = widget.minValue;
    maxController!.text = widget.maxValue;
    minController!.addListener(() {
      var baseOffset = minController!.value.selection.baseOffset;
      var extentOffset = minController!.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        minController!.value = minController!.value.copyWith(
          text: minController!.text
              .replaceAll('\u0660', '0')
              .replaceAll('\u0661', '1')
              .replaceAll('\u0662', '2')
              .replaceAll('\u0663', '3')
              .replaceAll('\u0664', '4')
              .replaceAll('\u0665', '5')
              .replaceAll('\u0666', '6')
              .replaceAll('\u0667', '7')
              .replaceAll('\u0668', '8')
              .replaceAll('\u0669', '9'),
          selection: TextSelection(
              baseOffset: minController!.text.length,
              extentOffset: minController!.text.length),
          composing: TextRange.empty,
        );
      }
    });
    maxController!.addListener(() {
      var baseOffset = maxController!.value.selection.baseOffset;
      var extentOffset = maxController!.value.selection.extentOffset;

      if (baseOffset == extentOffset) {
        maxController!.value = maxController!.value.copyWith(
          text: maxController!.text
              .replaceAll('\u0660', '0')
              .replaceAll('\u0661', '1')
              .replaceAll('\u0662', '2')
              .replaceAll('\u0663', '3')
              .replaceAll('\u0664', '4')
              .replaceAll('\u0665', '5')
              .replaceAll('\u0666', '6')
              .replaceAll('\u0667', '7')
              .replaceAll('\u0668', '8')
              .replaceAll('\u0669', '9'),
          selection: TextSelection(
              baseOffset: maxController!.text.length,
              extentOffset: maxController!.text.length),
          composing: TextRange.empty,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
        ),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: widget.padding!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDialogColumn(false),
                    _buildDialogColumn(true),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              right: -10,
              top: -5,
              child: IconButton(
                icon: Icon(
                  clearIcon,
                  size: pageIconSize,
                  color: darkColor,
                ),
                onPressed: () => Navigator.pop(context),
              )),
        ]),
      ),
    );
  }

  Widget _buildDialogColumn(isMax) {
    double? columnWidth = (widget.width! - widget.padding! * 2) / 2 - 10;
    double? columnHeight = (widget.width! - widget.padding! * 2) / 8 - 5;
    return Container(
      width: columnWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            isMax
                ? 'areaModal.lbl_areaModal_max'.tr()
                : 'areaModal.lbl_areaModal_min'.tr(),
            style: TextStyle(
                color: darkColor,
                fontSize: pageSubtitleSize * 1.1,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: unitWidth * 6),
          Container(
            width: columnWidth,
            height: columnHeight,
            child: TextFormField(
              onTap: () {
                if (maxController!.text == 'filter.lbl_any'.tr()) {
                  maxController!.text = '';
                }
              },
              controller: isMax ? maxController : minController,
              style: TextStyle(
                color: greyColor,
                fontSize: pageSubtitleSize,
              ),
              inputFormatters: widget.inputFormatters,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: isMax ? 'filter.lbl_any'.tr() : '0',
                hintStyle: const TextStyle(color: greyColor),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: color,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: color,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: color,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          SizedBox(height: unitWidth * 10),
          Container(
            width: columnWidth,
            height: filterMinMaxSingleSelectDialogHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(unitWidth * 10),
              ),
              border: Border.all(color: greyColor),
            ),
            child: RadioSelectButton(
              items: widget.items!,
              value: isMax ? maxController!.text : minController!.text,
              itemWidth: filterRentFrequencyTapWidth,
              itemHeight: unitWidth * 30,
              itemSpace: filterOptionTapSpace,
              titleSize: pageSubtitleSize,
              radius: unitWidth * 20,
              selectedColor: primaryDark,
              unSelectedColor: transparentColor,
              selectedBorderColor: transparentColor,
              unSelectedBorderColor: transparentColor,
              selectedTitleColor: lightColor,
              unSelectedTitleColor: greyColor,
              // listStyle: true,
              isVertical: true,
              listStyle: true,
              translateFlag: false,
              onTap: (value, index) {
                if (isMax) {
                  if (value.toString() != maxController!.text) {
                    maxController!.text = value.toString();
                  }
                } else {
                  if (value.toString() != minController!.text) {
                    minController!.text = value.toString();
                    //   maxController.text = _language.getLocalString(anyTitle);
                  }
                }
                setState(() {});
              },
            ),
          ),
          SizedBox(height: unitWidth * 5),
          Container(
            width: columnWidth,
            child: CustomTextButton(
              title: isMax
                  ? 'areaModal.lbl_areaModal_done'.tr()
                  : 'areaModal.lbl_areaModal_reset'.tr(),
              titleSize: pageTextSize * 1.1,
              titleColor: isMax ? lightColor : primaryDark,
              buttonColor: isMax ? primaryDark : lightColor,
              borderColor: isMax ? primaryDark : primaryDark,
              radius: unitWidth * 10,
              onPressed: () => !isMax ? _onPressedReset() : _onPressedDone(),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressedReset() {
    minController!.text = '';
    maxController!.text = '';
    //   maxController.text = _language.getLocalString(anyTitle);
    setState(() {
      val = false;
      color = greyColor;
    });
  }

  void _onPressedDone() {
    if (maxController!.text == '') {
      maxController!.text = 'Any';
    } else if (minController!.text == '') {
      minController!.text = '0';
    }
    dynamic min = int.tryParse(minController!.text);
    dynamic max = int.tryParse(maxController!.text);

    if (maxController!.text == 'Any' || min <= max) {
      Navigator.pop(context, [minController!.text, maxController!.text]);
    } else {
      Fluttertoast.showToast(
          msg: 'addproperty.lbl_invalid_input'.tr(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5);
      setState(() {
        val = true;
        color = favoriteColor;
      });
    }
  }
}
