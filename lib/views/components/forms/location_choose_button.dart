import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class LocationChooseButton extends StatefulWidget {
  const LocationChooseButton(
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
      this.indexId,
      this.isVertical,
      this.stateValue,
      this.clickable,
      required this.notifyParent(location, locationId, index, locTxtEnglish)})
      : super(key: key);

  final bool? isVertical;
  final bool? clickable;
  final double? itemHeight;
  final List? items;
  final int? indexId;
  final double? itemSpace;
  final double? itemWidth;
  final double? radius;
  final Color? selectedBorderColor;
  final Color? selectedColor;
  final Color? selectedTitleColor;
  final String? stateValue;
  final double? titleSize;
  final Color? unSelectedBorderColor;
  final Color? unSelectedColor;
  final Color? unSelectedTitleColor;

  @override
  LocationChooseButtonState createState() => LocationChooseButtonState(
        stateValue: this.stateValue!,
      );

  final Function(String? location, String? locationId, int? index,
      String? locTxtEnglish)? notifyParent;
}

class LocationChooseButtonState extends State<LocationChooseButton> {
  LocationChooseButtonState({this.stateValue});
  final ItemScrollController _scrollController = ItemScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? stateValue;

  @override
  void initState() {
    super.initState();
  }

  asignState(index) async {
    if (widget.clickable!) {
      this.stateValue = widget.items![index][2];
      widget.notifyParent!(widget.items![index][1], widget.items![index][2],
          index, widget.items![index][0]);
      _scrollController.jumpTo(index: index);
    }
  }

  void updateState(String curVal) async {
    for (int i = 0; i < widget.items!.length; i++) {
      if (widget.items![i][2] == curVal) {
        this.stateValue = curVal;
        await app_instance.storage
            .write(key: "locationIdIndex", value: i.toString());
        _scrollController.jumpTo(index: i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
        key: _formKey,
        // reverse: (context.locale.toString() == "ar_AR") ? false : true,
        scrollDirection: !widget.isVertical! ? Axis.horizontal : Axis.vertical,
        itemScrollController: _scrollController,
        initialScrollIndex: widget.indexId!,
        itemCount: widget.items!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: widget.itemSpace!),
            width: widget.itemWidth,
            child: MaterialButton(
              height: widget.itemHeight,
              onPressed: () => this.asignState(index),
              color: (this.stateValue == widget.items![index][2])
                  ? widget.selectedColor
                  : widget.unSelectedColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
                side: BorderSide(
                  color: (this.stateValue! == widget.items![index][2])
                      ? widget.selectedBorderColor!
                      : widget.unSelectedBorderColor!,
                  width: 1,
                ),
              ),
              child: Text(
                widget.items![index][1],
                style: TextStyle(
                  color: (this.stateValue == widget.items![index][2])
                      ? widget.selectedTitleColor
                      : widget.unSelectedTitleColor,
                  fontSize: widget.titleSize,
                ),
              ).tr(),
            ),
          );
        });
  }
}
