import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String? title;
  final Color? titleColor;
  final double? titleSize;
  final double? padding;
  final double? width;
  final MainAxisAlignment? alignment;

  final double space;

  const TextLabel({
    super.key,
    @required this.title,
    @required this.titleColor,
    @required this.titleSize,
    @required this.padding,
    @required this.width,
    @required this.alignment,
    this.space = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(padding!),
      child: Row(
        mainAxisAlignment: alignment!,
        children: <Widget>[
          SizedBox(width: space),
          Expanded(
            child: Text(title!,
                style: TextStyle(color: titleColor, fontSize: titleSize)),
          ),
        ],
      ),
    );
  }
}
