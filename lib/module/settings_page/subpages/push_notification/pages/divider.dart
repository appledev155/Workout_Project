import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DividerPage extends StatefulWidget {
  const DividerPage({super.key});

  @override
  State<DividerPage> createState() => _DividerPageState();
}

class _DividerPageState extends State<DividerPage> {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 0.5,
      color: Colors.grey,
      height: 30,
    );
  }
}
