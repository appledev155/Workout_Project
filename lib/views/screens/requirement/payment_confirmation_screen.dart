import 'package:flutter/services.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../module/request/pages/my_request_screen.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  @override
  _PaymentConfirmationScreenState createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  DateTime currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil(ModalRoute.withName('/search_result'));
          return false;
        },
        child: Scaffold(
          backgroundColor: lightColor,
          appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            backgroundColor: lightColor,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: const Text(
              'propertyDetails.lbl_pro_status',
              style: TextStyle(color: blackColor),
            ).tr(),
            iconTheme: const IconThemeData(color: blackColor),
          ),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  checkmarkIcon,
                  color: activeColor,
                  size: 100.sp,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'request.lbl_payment_success',
                  style: TextStyle(
                      color: blackColor,
                      fontSize: pageTitleSize,
                      fontWeight: FontWeight.w500),
                ).tr(),
                const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    DateFormat('MMMM dd yyyy').format(DateTime.now()),
                    style: TextStyle(fontSize: pageTextSize, color: greyColor),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(DateFormat.jm().format(DateTime.now()),
                      style:
                          TextStyle(fontSize: pageTextSize, color: greyColor))
                ]),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: primaryDark),
                  child: const Text(
                    'request.lbl_view_request',
                    style: TextStyle(color: lightColor),
                  ).tr(),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyRequestsScreen())),
                )
              ],
            ),
          ),
        ));
  }
}
