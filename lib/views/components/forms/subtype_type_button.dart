import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:core';

class SubTypeButton extends StatefulWidget {
  final List? items;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final Color? selectedBorderColor;
  final Color? unSelectedBorderColor;
  final Color? selectedTitleColor;
  final Color? unSelectedTitleColor;
  final double? itemWidth;
  final double? itemHeight;
  final double? itemSpace;
  final double? titleSize;
  final double? radius;
  final bool? isVertical;
  final bool? clickable;
  final String? stateValue;
  final String? propertyType;
  final Function(dynamic selVal)? notifyParent;

  SubTypeButton(
      {Key? key,
      this.items,
      this.selectedColor,
      this.unSelectedColor,
      this.selectedBorderColor,
      this.unSelectedBorderColor,
      this.selectedTitleColor,
      this.unSelectedTitleColor,
      this.itemWidth,
      this.itemHeight,
      this.itemSpace,
      this.titleSize,
      this.radius,
      this.isVertical,
      this.clickable,
      this.stateValue,
      this.propertyType,
      required this.notifyParent(selVal)})
      : super(key: key);
  @override
  SubTypeButtonState createState() => SubTypeButtonState(
      stateValue: this.stateValue,
      items: this.items,
      propertyType: this.propertyType);
}

class SubTypeButtonState extends State<SubTypeButton> {
  String? stateValue;
  List? items;
  String? propertyType;

  SubTypeButtonState({this.stateValue, this.items, this.propertyType});
  void initState() {
    super.initState();
  }

  asignState(item) async {
    if (widget.clickable!) {
      setState(() {
        this.stateValue = item['id'].toString();
      });
      widget.notifyParent!(item);
    }
  }

  void updateState(String curVal) {
    setState(() {
      this.propertyType = curVal;
      this.stateValue = '0';
    });
    // widget.notifyParent([]);
  }

  @override
  Widget build(BuildContext context) {
    List resItems;
    if (propertyType == 'residential') {
      resItems = items![0].runtimeType != Null ? items![0] : [];
    } else {
      resItems = items![1].runtimeType != Null ? items![1] : [];
    }

    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 10.0),
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 5,
      mainAxisSpacing: 5,
      children: resItems
          .map(
            (item) => Container(
              width: widget.itemWidth,
              margin: EdgeInsets.symmetric(horizontal: widget.itemSpace!),
              child: MaterialButton(
                height: widget.itemHeight,
                onPressed: () => this.asignState(item),
                color: (this.stateValue == item['id'].toString())
                    ? widget.selectedColor
                    : widget.unSelectedColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.radius!)),
                  side: BorderSide(
                    color: (this.stateValue == item!['id'].toString())
                        ? widget.selectedBorderColor!
                        : widget.unSelectedBorderColor!,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    "DATABASE_VAR." + item['name'],
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      color: (this.stateValue == item['id'].toString())
                          ? widget.selectedTitleColor
                          : widget.unSelectedTitleColor,
                      fontSize: widget.titleSize,
                    ),
                  ).tr(),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
