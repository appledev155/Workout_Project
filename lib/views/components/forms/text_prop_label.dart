import 'package:anytimeworkout/config/styles.dart';
import 'package:flutter/material.dart';

class TextPropLabel extends StatefulWidget {
  const TextPropLabel({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  TextPropLabelState createState() => TextPropLabelState();
}

class TextPropLabelState extends State<TextPropLabel> {
  TextPropLabelState({this.title});

  String? title;
  @override
  void initState() {
    super.initState();
  }

  updateState(String? curVal) {
    setState(() {
      title = curVal;
    });
  }

  updateStateResult(String? curVal) {
    title = curVal;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$title",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: pageIconSize),
    );
  }
}
