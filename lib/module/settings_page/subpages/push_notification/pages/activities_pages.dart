import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/divider.dart';
import 'package:flutter/material.dart';

import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;

import '../../../../../config/styles.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});
  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool kudos = false;
  bool comments = false;
  bool other_activities = false;
  bool mentions = false;
  bool lost_cr = false;
  bool device = false;
  bool beacon = false;
  bool add_activities = false;
  bool reminders = false;
  bool segment_analysis = false;
  bool activity_crop = false;
  bool elevation = false;
  bool progress_completion = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  List<String> activities = [];

  getactivitiesvalue() async {
    List<NotificationPush> getvalue = await operationstore.getactivitiesvalue();
    print(getvalue);
    if (getvalue.isNotEmpty) {
      print(getvalue.first.acitivities);

      for (var item in getvalue) {
        setState(() {
          activities = item.acitivities!;
        });
        setState(() {
          if (activities.contains("Kudos and Likes")) {
            kudos = true;
          }

          if (activities.contains("Comments")) {
            comments = true;
          }
          if (activities.contains("Comments on others' Activities")) {
            other_activities = true;
          }
          if (activities.contains("Mentions on Activities")) {
            mentions = true;
          }
          if (activities.contains("Lost CR")) {
            lost_cr = true;
          }
          if (activities.contains("Device Activity Synced")) {
            device = true;
          }
          if (activities.contains("Beacon")) {
            beacon = true;
          }
          if (activities.contains("Add to Activities")) {
            add_activities = true;
          }
          if (activities.contains("Upload Reminders")) {
            reminders = true;
          }
          if (activities.contains("Segment Analysis")) {
            segment_analysis = true;
          }
          if (activities.contains("Activity Crop")) {
            activity_crop = true;
          }
          if (activities.contains("Activity Elevation Adjustment")) {
            elevation = true;
          }
          if (activities.contains("Progress Completion")) {
            progress_completion = true;
          }
        });
      }
    }
    print("Activity list =====================$activities");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getactivitiesvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
            child: Text(
              'Activities',
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
                title: Text('Kudos and Likes',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    'Notify mw when I receive kudos on my activities or likes on my comments',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: kudos,
                onChanged: (value) {
                  setState(() {
                    kudos = value!;
                    print(kudos);
                    if (kudos == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Kudos and Likes');
                      activities = tempActivities;
                    } else if (kudos == false) {
                      if (activities.contains('Kudos and Likes')) {
                        var tempActivities = List<String>.from(activities);
                        print(tempActivities);
                        tempActivities.remove('Kudos and Likes');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Comments',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text('Notify me when someone comments on my activity',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: comments,
                onChanged: (value) {
                  setState(() {
                    comments = value!;
                    print(comments);
                    if (comments == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Comments');
                      activities = tempActivities;
                    } else if (comments == false) {
                      if (activities.contains('Comments')) {
                        var tempActivities = List<String>.from(activities);
                        print(tempActivities);
                        tempActivities.remove('Comments');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('''Comments on others' Activities''',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    '''Notify me when someone comments on an activity I commented on''',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: other_activities,
                onChanged: (value) {
                  setState(() {
                    other_activities = value!;
                    if (other_activities == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('''Comments on others' Activities''');
                      activities = tempActivities;
                    } else if (other_activities == false) {
                      if (activities
                          .contains('''Comments on others' Activities''')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities
                            .remove('''Comments on others' Activities''');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Mentions on Activities',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    'Notify me when someone mentions me in an activity',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: mentions,
                onChanged: (value) {
                  setState(() {
                    mentions = value!;
                    if (mentions == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Mentions on Activities');
                      activities = tempActivities;
                    } else if (mentions == false) {
                      if (activities.contains('Mentions on Activities')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities.remove('Mentions on Activities');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Lost CR',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    'Notify me when I lose the top place on a leaderboard',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: lost_cr,
                onChanged: (value) {
                  setState(() {
                    lost_cr = value!;
                    if (lost_cr == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Lost CR');
                      activities = tempActivities;
                    } else if (lost_cr == false) {
                      if (activities.contains('Lost CR')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities.remove('Lost CR');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Device Activity Synced',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    'Notify me when an activity from my device syncs to strava',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: device,
                onChanged: (value) {
                  setState(() {
                    device = value!;
                    if (device == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Device Activity Synced');
                      activities = tempActivities;
                    } else if (device == false) {
                      if (activities.contains('Device Activity Synced')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities.remove('Device Activity Synced');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Add to Activities',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    'Notify me when someone sends me their activity so I can save it to my profile',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: add_activities,
                onChanged: (value) {
                  setState(() {
                    add_activities = value!;
                    if (add_activities == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Add to Activities');
                      activities = tempActivities;
                    } else if (add_activities == false) {
                      if (activities.contains('Add to Activities')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities.remove('Add to Activities');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Upload Reminders',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text('Notify me to remind me to upload',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: reminders,
                onChanged: (value) {
                  setState(() {
                    reminders = value!;
                    if (reminders == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Upload Reminders');
                      activities = tempActivities;
                    } else if (reminders == false) {
                      if (activities.contains('Upload Reminders')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities.remove('Upload Reminders');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Segment Analysis',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    'Notify me with analysis of segmemt efforts on my recent activities',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: segment_analysis,
                onChanged: (value) {
                  setState(() {
                    segment_analysis = value!;
                    if (segment_analysis == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Segment Analysis');
                      activities = tempActivities;
                    } else if (segment_analysis == false) {
                      if (activities.contains('Segment Analysis')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities.remove('Segment Analysis');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text('Progress Completion',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Text(
                    'Notify me when I reach an activity milestone or complete a goal',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
                value: progress_completion,
                onChanged: (value) {
                  setState(() {
                    progress_completion = value!;
                    if (progress_completion == true) {
                      var tempActivities = List<String>.from(activities);
                      tempActivities.add('Progress Completion');
                      activities = tempActivities;
                    } else if (progress_completion == false) {
                      if (activities.contains('Progress Completion')) {
                        var tempActivities = List<String>.from(activities);
                        tempActivities.remove('Progress Completion');
                        activities = tempActivities;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 1, acitivities: activities);
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
    );
  }
}
