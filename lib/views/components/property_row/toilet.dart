import 'package:anytimeworkout/config/styles.dart';

import '../../../config/icons.dart';
import 'package:flutter/material.dart';

class Toilet extends StatelessWidget {
  final int? toilet;
  const Toilet({Key? key, this.toilet})
      : assert(toilet != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      if (this.toilet! > 0) ...[
        Icon(
          bathIcon,
          size: pageIconSize,
        ),
        const SizedBox(width: 5),
        Text("$toilet"),
      ],
    ]);
  }
}
