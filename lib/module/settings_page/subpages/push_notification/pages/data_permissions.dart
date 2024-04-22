import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/divider.dart';
import 'package:flutter/material.dart';

import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;

class DataPermissionPage extends StatefulWidget {
  const DataPermissionPage({super.key});

  @override
  State<DataPermissionPage> createState() => _DataPermissionPageState();
}

class _DataPermissionPageState extends State<DataPermissionPage> {
  bool health_data = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  getdatavalue() async {
    List<NotificationPush> getvalue = await operationstore.getdatavalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        health_data =
            (getvalue.first.dataselectedvalue == 'false') ? false : true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatavalue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
              child: Text(
                'Data Permissions',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: drawerMenuItemSize,
                    color: blackColorDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: CheckboxListTile(
                  activeColor: primaryColor,
                  title: Text(
                    'Health Data',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  ),
                  subtitle: Text(
                    '''Notify me when I upload a file that includes health data that I haven't given Strava consent to process''',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight),
                  ),
                  value: health_data,
                  onChanged: (value) {
                    setState(() {
                      health_data = value!;
                      NotificationPush getvalue = NotificationPush(
                          id: 7, dataselectedvalue: health_data.toString());
                      operationstore.insert(getvalue);
                    });
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}
