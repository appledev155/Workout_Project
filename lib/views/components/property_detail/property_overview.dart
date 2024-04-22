import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';

import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PropertyOverview extends StatelessWidget {
  final String? type;
  final String? price;
  final String? propertyType;
  final int? bedrooms;
  final int? toilet;
  final String? propertyStatus;
  final String? purpose;
  final String? buildYear;
  final String? currency = 'currency.AED'.tr();

  PropertyOverview({
    Key? key,
    @required this.type,
    this.price,
    this.propertyType,
    this.bedrooms,
    this.toilet,
    this.propertyStatus,
    this.purpose,
    this.buildYear,
  })  : assert(type != ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String rec, purposeText, propertyStatusText;
    rec = (this.propertyType == '1')
        ? 'filter.lbl_residential'.tr()
        : 'filter.lbl_commercial'.tr() +
            ' ' +
            'propertyDetails.lbl_property_type'.tr();

    purposeText = (this.purpose == 'Sell')
        ? 'filter.lbl_for_sale'.tr()
        : 'filter.lbl_for_rent'.tr();

    propertyStatusText = (this.propertyStatus == '1' || this.purpose == 'Rent')
        ? 'addproperty.lbl_ready_to_move_in'.tr() +
            ' ' +
            this.buildYear.toString()
        : 'addproperty.lbl_under_construnction'.tr();

    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(completionStatusIcon,
                          size: pageIconSize * 1.02, color: greyColor),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$rec',
                        style: TextStyle(
                            fontSize: pageIconSize * 1.02,
                            color: greyColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('DATABASE_VAR.$type').tr(),
                  const SizedBox(height: 10),
                  if (this.propertyStatus != '-1' ||
                      this.purpose == 'Rent') ...[
                    Row(
                      children: [
                        Icon(checkmarkIcon,
                            size: pageIconSize * 1.02, color: greyColor),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'propertyDetails.lbl_pro_status',
                          style: TextStyle(
                              fontSize: pageIconSize * 1.02,
                              color: greyColor,
                              fontWeight: FontWeight.w500),
                        ).tr()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("$propertyStatusText"),
                    const SizedBox(height: 10),
                  ],
                  if (this.bedrooms! > 0) ...[
                    Row(
                      children: [
                        Icon(
                          bedroomIcon,
                          size: pageIconSize * 1.02,
                          color: greyColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'filter.lbl_bedrooms',
                          style: TextStyle(
                              fontSize: pageIconSize * 1.02,
                              color: greyColor,
                              fontWeight: FontWeight.w500),
                        ).tr()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("$bedrooms"),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(currencyIcon,
                          size: pageIconSize * 1.02, color: greyColor),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'propertyDetails.lbl_property_price',
                        style: TextStyle(
                            fontSize: pageIconSize * 1.02,
                            color: greyColor,
                            fontWeight: FontWeight.w500),
                      ).tr()
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (price!.length < 2) ...[
                    const Text("list.lbl_call_for_price").tr()
                  ] else ...[
                    Text("$price $currency"),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(homeIcon,
                          size: pageIconSize * 1.02, color: greyColor),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('propertyDetails.lbl_property_purpose',
                              style: TextStyle(
                                  fontSize: pageIconSize * 1.02,
                                  color: greyColor,
                                  fontWeight: FontWeight.w500))
                          .tr()
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text("$purposeText"),
                  const SizedBox(height: 10),
                  if (this.toilet! > 0) ...[
                    Row(
                      children: [
                        Icon(bathIcon,
                            size: pageIconSize * 1.02, color: greyColor),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'filter.lbl_bathrooms',
                          style: TextStyle(
                              fontSize: pageIconSize * 1.02,
                              color: greyColor,
                              fontWeight: FontWeight.w500),
                        ).tr()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("$toilet"),
                  ],
                ],
              ),
            ]));
  }
}
