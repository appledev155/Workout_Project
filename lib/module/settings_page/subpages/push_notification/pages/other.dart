import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;
import 'package:flutter/material.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  bool marketing = false;
  bool feature_subscription = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  List<String> other = [];
  getothervalue() async {
    List<NotificationPush> getvalue = await operationstore.getothervalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        for (var item in getvalue) {
          other = item.other!;
        }
      });
      setState(() {
        if (other.contains('Marketing')) {
          marketing = true;
        }
        if (other.contains('Feature and Subscription Tips')) {
          feature_subscription = true;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getothervalue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Text(
              'Other',
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
                  'Marketing',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Alllow Strava to send me push notifications about promotions or other marketing announcements.',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: marketing,
                onChanged: (value) {
                  setState(() {
                    marketing = value!;
                    if (marketing == true) {
                      var tempother = List<String>.from(other);
                      tempother.add('Marketing');
                      other = tempother;
                    } else if (marketing == false) {
                      if (other.contains('Marketing')) {
                        var tempother = List<String>.from(other);
                        tempother.remove('Marketing');
                        other = tempother;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 8, other: other);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Feature and Subscription Tips',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Receive announcements about new features and tips for how to best use them.',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: feature_subscription,
                onChanged: (value) {
                  setState(() {
                    feature_subscription = value!;
                    if (feature_subscription == true) {
                      var tempother = List<String>.from(other);
                      tempother.add('Feature and Subscription Tips');
                      other = tempother;
                    } else if (feature_subscription == false) {
                      if (other.contains('Feature and Subscription Tips')) {
                        var tempother = List<String>.from(other);
                        tempother.remove('Feature and Subscription Tips');
                        other = tempother;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 8, other: other);
                    operationstore.insert(getvalue);
                  });
                }),
          )
        ],
      ),
    );
  }
}
