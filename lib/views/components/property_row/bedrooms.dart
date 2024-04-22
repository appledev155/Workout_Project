import 'package:anytimeworkout/config/styles.dart';

import '../../../config/icons.dart';
import 'package:flutter/material.dart';

class Bedrooms extends StatelessWidget {
  final int? bedrooms;
  const Bedrooms({Key? key, this.bedrooms})
      : assert(bedrooms != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      if (this.bedrooms! > 0) ...[
        Icon(
          bedroomIcon,
          size: pageIconSize,
        ),
        const SizedBox(width: 10),
        Text("$bedrooms"),
        //SizedBox(width: 4),
      ],
    ]);
  }
}
