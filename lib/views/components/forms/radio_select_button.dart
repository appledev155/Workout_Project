import 'package:flutter/material.dart';
import 'dart:core';
import 'package:easy_localization/easy_localization.dart';

class RadioSelectButton extends StatefulWidget {
  final List? items;
  final String? value;
  final String? values;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final Color? selectedBorderColor;
  final Color? unSelectedBorderColor;
  final Color? selectedTitleColor;
  final Color? unSelectedTitleColor;
  final bool? centerItem;
  final double? itemWidth;
  final double? itemHeight;
  final double? itemSpace;
  final double? titleSize;
  final double? radius;
  final bool? isVertical;
  final Function? onTap;
  final bool? listStyle;
  final bool? translateFlag;

  RadioSelectButton({
    this.items,
    this.value,
    this.values,
    this.itemWidth,
    this.itemHeight,
    this.itemSpace,
    this.titleSize,
    this.radius,
    this.selectedColor,
    this.unSelectedColor,
    this.selectedTitleColor,
    this.unSelectedTitleColor,
    this.selectedBorderColor,
    this.unSelectedBorderColor,
    this.centerItem = true,
    this.isVertical = false,
    this.listStyle = false,
    this.onTap,
    this.translateFlag = false,
  });

  @override
  RadioSelectButtonState createState() => RadioSelectButtonState();
}

class RadioSelectButtonState extends State<RadioSelectButton> {
  @override
  Widget build(BuildContext context) {
    return !widget.listStyle!
        ? Wrap(
            direction: !widget.isVertical! ? Axis.horizontal : Axis.vertical,
            alignment: WrapAlignment.start,
            spacing: widget.itemSpace!,
            children: List.generate(
              widget.items!.length,
              (index) => Container(
                width: widget.itemWidth,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: widget.values != null &&
                              widget.values!
                                  .contains(widget.items![index].toString())
                          ? widget.selectedColor
                          : widget.unSelectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(widget.radius!)),
                        side: BorderSide(
                          color: widget.values != null &&
                                  widget.values!
                                      .contains(widget.items![index].toString())
                              ? widget.selectedBorderColor!
                              : widget.unSelectedBorderColor!,
                          width: 1,
                        ),
                      )),
                  onPressed: () =>
                      widget.onTap!(widget.items![index].toString()),
                  child: Center(
                    child: Text(
                      widget.items![index].toString(),
                      style: TextStyle(
                        color: widget.values != null &&
                                widget.values!
                                    .contains(widget.items![index].toString())
                            ? widget.selectedTitleColor
                            : widget.unSelectedTitleColor,
                        fontSize: widget.titleSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : ListView(
            scrollDirection:
                widget.isVertical! ? Axis.vertical : Axis.horizontal,
            children: List.generate(
              widget.items!.length,
              (index) => Container(
                width: widget.itemWidth,
                margin: EdgeInsets.symmetric(horizontal: widget.itemSpace!),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: widget.value ==
                                widget.items![index].toString() ||
                            (widget.values != null &&
                                widget.values!
                                    .contains(widget.items![index].toString()))
                        ? widget.selectedColor
                        : widget.unSelectedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(widget.radius!)),
                      side: BorderSide(
                        color:
                            widget.value == widget.items![index].toString() ||
                                    (widget.values != null &&
                                        widget.values!.contains(
                                            widget.items![index].toString()))
                                ? widget.selectedBorderColor!
                                : widget.unSelectedBorderColor!,
                        width: 1,
                      ),
                    ),
                  ),
                  onPressed: () =>
                      widget.onTap!(widget.items![index].toString(), index),
                  child: Center(
                    child: (widget.translateFlag!)
                        ? Text(
                            widget.items![index].toString(),
                            style: TextStyle(
                              color: widget.value ==
                                          widget.items![index].toString() ||
                                      (widget.values != null &&
                                          widget.values!.contains(
                                              widget.items![index].toString()))
                                  ? widget.selectedTitleColor
                                  : widget.unSelectedTitleColor,
                              fontSize: widget.titleSize,
                            ),
                          ).tr()
                        : Text(
                            widget.items![index].toString(),
                            style: TextStyle(
                              color: widget.value ==
                                          widget.items![index].toString() ||
                                      (widget.values != null &&
                                          widget.values!.contains(
                                              widget.items![index].toString()))
                                  ? widget.selectedTitleColor
                                  : widget.unSelectedTitleColor,
                              fontSize: widget.titleSize,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          );
  }
}
