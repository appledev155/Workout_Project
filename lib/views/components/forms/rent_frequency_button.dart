import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class RentFrequencyButton extends StatefulWidget {
  const RentFrequencyButton(
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
      required this.onTap(index)})
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
  final int? stateValue;
  final double? titleSize;
  final Color? unSelectedBorderColor;
  final Color? unSelectedColor;
  final Color? unSelectedTitleColor;

  @override
  RentFrequencyButtonState createState() => RentFrequencyButtonState(
        stateValue: this.stateValue!,
      );

  final Function(int index) onTap;
}

class RentFrequencyButtonState extends State<RentFrequencyButton> {
  RentFrequencyButtonState({this.stateValue});
  final ItemScrollController _scrollController = ItemScrollController();
  int? stateValue;

  void initState() {
    super.initState();
  }

  asignState(index) async {
    if (widget.clickable!) {
      this.stateValue = index;
      widget.onTap(index);
    }
  }

  void updateState(int curVal) async {
    for (int i = 0; i < widget.items!.length; i++) {
      if (widget.items![i][2] == curVal) {
        this.stateValue = curVal;
        _scrollController.jumpTo(index: i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
        scrollDirection: !widget.isVertical! ? Axis.horizontal : Axis.vertical,
        itemScrollController: _scrollController,
        initialScrollIndex: this.stateValue!,
        itemCount: widget.items!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: widget.itemSpace!),
            width: widget.itemWidth,
            child: MaterialButton(
              height: widget.itemHeight,
              onPressed: () => this.asignState(index),
              color: (this.stateValue == index)
                  ? widget.selectedColor
                  : widget.unSelectedColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
                side: BorderSide(
                  color: (this.stateValue == index)
                      ? widget.selectedBorderColor!
                      : widget.unSelectedBorderColor!,
                  width: 1,
                ),
              ),
              child: Text(
                widget.items![index],
                style: TextStyle(
                  color: (this.stateValue == index)
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
