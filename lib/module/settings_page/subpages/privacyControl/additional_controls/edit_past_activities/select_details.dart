import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/edit_past_activities/select_details/operation.dart'
    as details_store;
import 'package:anytimeworkout/isar/edit_past_activities/select_details/selectdetail.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/activity_visibility.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/edit_activities.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/heart_rate_visibility.dart';
import 'package:flutter/material.dart';

enum Detailslist { activity_visibility, heart_rate_visibility }

class SelectDetailsPage extends StatefulWidget {
  const SelectDetailsPage({super.key});

  @override
  State<SelectDetailsPage> createState() => _SelectDetailsPageState();
}

class _SelectDetailsPageState extends State<SelectDetailsPage> {
  details_store.SelectDetailOperation detailsstore =
      details_store.SelectDetailOperation();
  Detailslist? detailslist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditActivitiesPage()));
              wait();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          'Select Details',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: pageTitleSize,
              color: lightColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (detailslist == Detailslist.activity_visibility) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            const ActivityVisibilityPage())));
              } else if (detailslist == Detailslist.heart_rate_visibility) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            const HeartRateVisibilityPage())));
              }
            },
            child: detailslist == Detailslist.activity_visibility ||
                    detailslist == Detailslist.heart_rate_visibility
                ? Text(
                    'NEXT',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: pageIconSize,
                        color: lightColor),
                  )
                : Text(
                    'NEXT',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: pageIconSize,
                        color: lightColor),
                  ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 20),
                child: Text(
                  'Select the details you would like to change below.',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: dividerColor,
              ),
              RadioListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: Detailslist.activity_visibility,
                  groupValue: detailslist,
                  toggleable: true,
                  title: Text(
                    'Activity Visibility',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  ),
                  onChanged: (Detailslist? value) {
                    setState(() {
                      detailslist = value;
                      SelectDetail getvalue = SelectDetail(
                          id: 1,
                          selectdetailsvalue:
                              Detailslist.activity_visibility.toString());
                      detailsstore.insert(getvalue);
                    });
                  }),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: dividerColor,
              ),
              RadioListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: Detailslist.heart_rate_visibility,
                  groupValue: detailslist,
                  toggleable: true,
                  title: Text(
                    'Heart Rate Visibility',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  ),
                  onChanged: (Detailslist? value) {
                    setState(() {
                      detailslist = value;
                      SelectDetail getvalue = SelectDetail(
                          id: 1,
                          selectdetailsvalue:
                              Detailslist.heart_rate_visibility.toString());
                      detailsstore.insert(getvalue);
                    });
                  }),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void wait() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const CircularProgressIndicator(color: primaryColor),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Please wait...',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  )
                ],
              ),
            ),
          );
        });
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }
}
