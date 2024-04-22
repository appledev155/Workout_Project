import '../../../config/styles.dart';
import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Price extends StatelessWidget {
  final String? price;
  final String? currency = 'currency.AED'.tr();
  final String callForPrice = 'list.lbl_call_for_price'.tr();

  Price({Key? key, required this.price}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RichText(
        strutStyle: StrutStyle(
          fontFamily: 'DM Sans',
          forceStrutHeight:
              (context.locale.toString() == 'ar_AR') ? true : false,
        ),
        text: (price!.length < 2)
            ? TextSpan(
                text: callForPrice,
                style: TextStyle(
                  fontSize: pageTitleSize,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ))
            : TextSpan(
                text: "$price",
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: pageTitleSize,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
                children: [
                    TextSpan(
                        text: " $currency",
                        style: TextStyle(
                          fontSize: pageTitleSize,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        )),
                  ]));
  }
}
