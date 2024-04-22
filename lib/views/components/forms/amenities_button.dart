import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:core';

class AmenitiesButton extends StatefulWidget {
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
  final String? stateValue;
  final String? propertyType;
  final Function(String? selVal)? notifyParent;
  final Function? onTap;
  final List? values;

  const AmenitiesButton(
      {Key? key,
      this.items = const [],
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
      this.stateValue = '',
      this.propertyType = '',
      this.onTap,
      this.values,
      this.notifyParent})
      : super(key: key);
  @override
  AmenitiesButtonState createState() => AmenitiesButtonState(
      stateValue: this.stateValue!,
      items: this.items!,
      propertyType: this.propertyType!);
}

class AmenitiesButtonState extends State<AmenitiesButton> {
  String? stateValue;
  List? items;
  String? propertyType;

  AmenitiesButtonState({this.stateValue, this.items, this.propertyType});
  void initState() {
    super.initState();
  }

  asignState(id) async {
    setState(() {
      this.stateValue = id;
    });
    widget.notifyParent!(id);
  }

  void updateState(String curVal) {
    setState(() {
      this.propertyType = curVal;
      this.stateValue = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    List resItems;
    resItems = this.items![0];

    return GridView.count(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      crossAxisCount: 1,
      childAspectRatio: 5.0,
      mainAxisSpacing: 2,
      children: resItems
          .map(
            (item) => Container(
              width: widget.itemWidth,
              margin: EdgeInsets.symmetric(
                  horizontal: widget.itemSpace!, vertical: 4),
              child: MaterialButton(
                height: widget.itemHeight,
                onPressed: () {
                  var title = item['name'].toString();
                  widget.onTap!(item['id'].toString(), title);
                },
                color: widget.stateValue == item['id'].toString() ||
                        (widget.values != null &&
                            widget.values!.contains(item['id'].toString()))
                    ? widget.selectedColor
                    : widget.unSelectedColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.radius!)),
                  side: BorderSide(
                    color: widget.stateValue! == item!['id'].toString() ||
                            (widget.values! != null &&
                                widget.values!.contains(item['id'].toString()))
                        ? widget.selectedBorderColor!
                        : widget.unSelectedBorderColor!,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    "DATABASE_VAR." + item['name'],
                    style: TextStyle(
                      color: widget.stateValue == item['id'].toString() ||
                              (widget.values != null &&
                                  widget.values!
                                      .contains(item['id'].toString()))
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
