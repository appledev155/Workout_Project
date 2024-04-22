import 'package:flutter/material.dart';

class SelectableContainer extends StatefulWidget {
  final Color? selectedBackgroundColor;

  final Color? unselectedBackgroundColor;

  final Color? selectedBorderColor;

  final Color? unselectedBorderColor;

  final Color? iconColor;

  final int? iconSize;

  final Widget? child;

  final int? borderSize;

  final Function? onPressed;

  final double? unselectedOpacity;

  final int? opacityAnimationDuration;

  final IconData? icon;

  final Alignment? iconAlignment;

  final double? padding;

  final double? elevation;

  final double? borderRadius;

  final bool? selected;

  @override
  _SelectableContainerState createState() => _SelectableContainerState();

  const SelectableContainer(
      {super.key,
      this.selected,
      this.unselectedBackgroundColor,
      this.selectedBackgroundColor,
      this.selectedBorderColor,
      this.unselectedBorderColor,
      @required this.onPressed,
      this.iconSize = 16,
      this.iconColor = Colors.white,
      this.icon,
      this.iconAlignment = Alignment.topRight,
      this.borderSize = 2,
      this.unselectedOpacity = 0.5,
      this.opacityAnimationDuration = 600,
      this.padding = 0,
      this.elevation = 0.0,
      this.borderRadius = 10.0,
      this.child});
}

class _SelectableContainerState extends State<SelectableContainer> {
  Color? _selectedBackgroundColor;
  Color? _unselectedBackgroundColor;
  Color? _selectedBorderColor;
  Color? _unselectedBorderColor;
  IconData? _icon;
  bool? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  void assingDefaultValues() {
    var theme = Theme.of(context);

    _selectedBackgroundColor =
        this.widget.selectedBackgroundColor ?? theme.dialogBackgroundColor;
    _unselectedBackgroundColor =
        this.widget.unselectedBackgroundColor ?? theme.dialogBackgroundColor;
    _selectedBorderColor =
        this.widget.selectedBorderColor ?? theme.primaryColor;

    _unselectedBorderColor =
        this.widget.unselectedBorderColor ?? theme.primaryColorDark;

    _icon = this.widget.icon ?? Icons.check;
  }

  @override
  Widget build(BuildContext context) {
    assingDefaultValues();
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = !_selected!;
        });
        widget.onPressed!();
      },
      child: AnimatedOpacity(
        opacity: widget.selected! ? 1.0 : widget.unselectedOpacity!,
        duration: Duration(milliseconds: widget.opacityAnimationDuration!),
        child: Material(
          elevation: 0.0,
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                elevation: widget.elevation!,
                child: Stack(
                  alignment: widget.iconAlignment!,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(widget.iconSize! / 2),
                      padding: EdgeInsets.all(widget.padding!),
                      child: widget.child,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: widget.selected!
                                  ? _selectedBorderColor!
                                  : _unselectedBorderColor!,
                              width: widget.borderSize!.toDouble()),
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius!),
                          color: widget.selected!
                              ? _selectedBackgroundColor
                              : _unselectedBackgroundColor),
                    ),
                    Visibility(
                      visible: widget.selected!,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                          color: widget.selected!
                              ? _selectedBorderColor
                              : _unselectedBorderColor,
                        ),
                        child: Icon(
                          _icon,
                          size: widget.iconSize!.toDouble(),
                          color: widget.iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
