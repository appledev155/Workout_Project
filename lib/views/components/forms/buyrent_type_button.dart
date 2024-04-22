import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BuyrentTypeButton extends StatefulWidget {
  BuyrentTypeButton(
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
      this.stateValue,
      this.clickable,
      this.notifyParent})
      : super(key: key);

  final bool? isVertical;
  final bool? clickable;
  final double? itemHeight;
  final List? items;
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
  BuyrentTypeButtonState createState() => BuyrentTypeButtonState(
        stateValue: this.stateValue!,
      );

  final Function(String? selVal)? notifyParent;
}

class BuyrentTypeButtonState extends State<BuyrentTypeButton> {
  BuyrentTypeButtonState({this.stateValue});

  String? stateValue;

  void initState() {
    super.initState();
  }

  asignState(index) async {
    if (widget.clickable!) {
      setState(() {
        this.stateValue = widget.items![index][0];
      });
      widget.notifyParent!(widget.items![index][0]);
    }
  }

  void updateState(String curVal) {
    setState(() {
      this.stateValue = curVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: !widget.isVertical! ? Axis.horizontal : Axis.vertical,
      alignment: WrapAlignment.start,
      spacing: widget.itemSpace!,
      children: List.generate(
        widget.items!.length,
        (index) {
          return Container(
            width: widget.itemWidth,
            child: MaterialButton(
              height: widget.itemHeight,
              onPressed: () {
                this.asignState(index);
              },
              color: (this.stateValue == widget.items![index][0])
                  ? widget.selectedColor
                  : widget.unSelectedColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
                side: BorderSide(
                  color: (this.stateValue! == widget.items![index][0])
                      ? widget.selectedBorderColor!
                      : widget.unSelectedBorderColor!,
                  width: 1,
                ),
              ),
              child: Text(
                widget.items![index][1],
                style: TextStyle(
                    color: (this.stateValue == widget.items![index][0])
                        ? widget.selectedTitleColor
                        : widget.unSelectedTitleColor,
                    fontSize: widget.titleSize,
                    fontWeight: FontWeight.bold),
              ).tr(),
            ),
          );
        },
      ),
    );
  }
}
