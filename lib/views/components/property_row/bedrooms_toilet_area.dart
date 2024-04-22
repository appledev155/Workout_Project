import 'package:flutter/material.dart';
import 'area.dart';
import 'bedrooms.dart';
import 'toilet.dart';

class BedroomsToiletArea extends StatelessWidget {
  final int? bedrooms;
  final int? toilet;
  final String? areaSqft;
  final String? areaSqm;
  final String? areaSqyd;

  const BedroomsToiletArea(
      {Key? key,
      this.bedrooms,
      this.toilet,
      this.areaSqft,
      this.areaSqm,
      this.areaSqyd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Bedrooms(bedrooms: this.bedrooms!),
        const SizedBox(width: 3),
        Toilet(toilet: this.toilet!),
        const SizedBox(width: 3),
        Expanded(
            child: Area(
                areaSqft: this.areaSqft,
                areaSqm: this.areaSqm,
                areaSqyd: this.areaSqyd)),
      ],
    );
  }
}
