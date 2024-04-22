import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/edit_past_activities/activity_visibility/activityvisible.dart';
import 'package:anytimeworkout/isar/edit_past_activities/activity_visibility/operation.dart' as activityvisibility_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/activity_summary.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/select_details.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/where_you_appear/activities.dart';
import 'package:flutter/material.dart';


enum ActivityVisibility { Everyone, Followers, Only_You }

class ActivityVisibilityPage extends StatefulWidget {
  const ActivityVisibilityPage({super.key});

  @override
  State<ActivityVisibilityPage> createState() => _ActivityVisibilityPageState();
}

class _ActivityVisibilityPageState extends State<ActivityVisibilityPage> {
  activityvisibility_store.ActivityVisibleOperation activityvisibilitystore =
      activityvisibility_store.ActivityVisibleOperation();
  ActivityVisibility? activityVisibility;

  // getvalue() async {
  //   List<ActivityVisible> getvalue = await activityvisibilitystore.getvalue();
  //   getvalue.clear();

  //   if (getvalue.isNotEmpty) {
  //     setState(() {
  //       if (getvalue.first.Activityselectedvalue ==
  //           "ActivityVisibility.Everyone") {
  //         activityVisibility = ActivityVisibility.Everyone;
  //       } else if (getvalue.first.Activityselectedvalue ==
  //           "ActivityVisibility.Followers") {
  //         activityVisibility = ActivityVisibility.Followers;
  //       } else {
  //         activityVisibility = ActivityVisibility.Only_You;
  //       }
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getvalue();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SelectDetailsPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title:  Text(
          'Activity Visibility',
            style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageTitleSize,
                          color: lightColor),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (activityVisibility == ActivityVisibility.Everyone ||
                    activityVisibility == ActivityVisibility.Followers ||
                    activityVisibility == ActivityVisibility.Only_You) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivitySummaryPage(
                              selectvalue: (activityVisibility ==
                                      ActivityVisibility.Everyone)
                                  ? "Everyone"
                                  : (activityVisibility ==
                                          ActivityVisibility.Followers)
                                      ? "Followers"
                                      : "Only You")));
                }
              },
              child: activityVisibility == ActivityVisibility.Everyone ||
                      activityVisibility == ActivityVisibility.Followers ||
                      activityVisibility == ActivityVisibility.Only_You
                  ?  Text(
                      'NEXT',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: lightColor),
                    )
                  :  Text(
                      'NEXT',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: lightColor)
                    ))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
              child: RichText(
                  text:  TextSpan(children: [
                TextSpan(
                    text: 'Change the visibility of all past activities ',
                   style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: pageIconSize,
                          color: blackColorDark)),
                TextSpan(
                    text: 'by selecting a new setting.',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark))
              ])),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ActivitesPage()));
                },
                child: Text(
                  '''To set the default for future activities, use the privacy controls located here.''',
                  style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: primaryColor),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor:primaryColor,
                      title:  Text(
                        '''Update all past activities to "Everyone"''',
                         style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                      ),
                      subtitle:  Padding(
                        padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                        child: Text(
                          '''Set past activities to everyone so they appear on public segment leaderboards and will count toward challenges.They will also be visible to other Strava athletes.''',
                           style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight),
                        ),
                      ),
                      value: ActivityVisibility.Everyone,
                      groupValue: activityVisibility,
                      onChanged: (ActivityVisibility? value) {
                        setState(() {
                          activityVisibility = value;
                          ActivityVisible getvalue = ActivityVisible(
                              id: 1,
                              Activityselectedvalue:
                                  ActivityVisibility.Everyone.toString());
                          activityvisibilitystore.insert(getvalue);
                        });
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor:primaryColor,
                      title:  Text(
                        '''Update all past activities to "Followers"''',
                          style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                      ),
                      subtitle:  Padding(
                        padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                        child: Text(
                          '''Set past activities to followers so they no longer appear on public segment leaderboards nor count towards challenges that require an "Everyone" setting.Any previously earned top 10 achievements will be removed from activities.''',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight),
                        ),
                      ),
                      value: ActivityVisibility.Followers,
                      groupValue: activityVisibility,
                      onChanged: (ActivityVisibility? value) {
                        setState(() {
                          activityVisibility = value;
                          ActivityVisible getvalue = ActivityVisible(
                              id: 1,
                              Activityselectedvalue:
                                  ActivityVisibility.Followers.toString());
                          activityvisibilitystore.insert(getvalue);
                        });
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor:primaryColor,
                      title:  Text(
                        '''Update all past activities to "Only You"''',
                       style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                      ),
                      subtitle:  Padding(
                        padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                        child: Text(
                          '''Set past activities to only you so they no longer appear on public segment leaderboards nor count towards challenges that require an "Everyone" setting. Any previously earned top 10 achievements will be removed from activities.''',
                          style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight),
                        ),
                      ),
                      value: ActivityVisibility.Only_You,
                      groupValue: activityVisibility,
                      onChanged: (ActivityVisibility? value) {
                        setState(() {
                          activityVisibility = value;
                          ActivityVisible getvalue = ActivityVisible(
                              id: 1,
                              Activityselectedvalue:
                                  ActivityVisibility.Only_You.toString());
                          activityvisibilitystore.insert(getvalue);
                        });
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
