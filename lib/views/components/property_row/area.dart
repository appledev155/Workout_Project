import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:anytimeworkout/config.dart' as app_instance;

class Area extends StatefulWidget {
  final String? areaSqft;
  final String? areaSqm;
  final String? areaSqyd;

  Area({Key? key, this.areaSqft, this.areaSqm, this.areaSqyd})
      : super(key: key);
  @override
  _AreaState createState() => _AreaState();
}

class _AreaState extends State<Area> {
  Future<String>? getD;
  @override
  initState() {
    super.initState();
    getD = _getPropertyAreaUnit();
  }

  Future<String>? _getPropertyAreaUnit() async {
    return await app_instance.storage.read(key: 'propertyAreaUnit').toString();
  }

  @override
  Widget build(BuildContext context) {
    String? unit;
    String? lblunit = 'propertyDetails.lbl_sqft';

    return FutureBuilder<String>(
        future: getD,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.data) {
            case 'Sq. Ft.':
              unit = widget.areaSqft;
              lblunit = 'propertyDetails.lbl_sqft'.tr();
              break;
            case 'Sq. M.':
              unit = widget.areaSqm;
              lblunit = 'propertyDetails.lbl_sqm'.tr();
              break;
            case 'Sq. Yd.':
              unit = widget.areaSqyd;
              lblunit = 'propertyDetails.lbl_sqy'.tr();
              break;
            default:
              unit = widget.areaSqft;
              lblunit = 'propertyDetails.lbl_sqft'.tr();
          }

          return Text(
            '$unit $lblunit',
            overflow: TextOverflow.ellipsis,
          );
        });
  }
}
