import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/group_activities/groupactivity.dart';
import 'package:anytimeworkout/isar/group_activities/groupactivityoperation.dart'
    as gp_activity_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart';

enum GroupActivitylist { Everyone, Followers, NoOne }

class GroupActivityPage extends StatefulWidget {
  const GroupActivityPage({super.key});

  @override
  State<GroupActivityPage> createState() => _GroupActivityPageState();
}

class _GroupActivityPageState extends State<GroupActivityPage> {
  GroupActivitylist? _groupActivitylist = GroupActivitylist.Everyone;
  gp_activity_store.GroupActivityOperation gpactivitystore =
      gp_activity_store.GroupActivityOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    List<GroupActivity> getactivityvalue =
        await gpactivitystore.getgroupactivity();
    if (getactivityvalue.isNotEmpty) {
      setState(() {
        if (getactivityvalue.first.group_activity_selectevalue ==
            "GroupActivitylist.Everyone") {
          _groupActivitylist = GroupActivitylist.Everyone;
        } else if (getactivityvalue.first.group_activity_selectevalue ==
            "GroupActivitylist.Followers") {
          _groupActivitylist = GroupActivitylist.Followers;
        } else {
          _groupActivitylist = GroupActivitylist.NoOne;
        }
      });
    }
  }

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
                      builder: (context) => PrivacyControlPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title:  Text(
          'Group Activities',
          style: TextStyle(fontSize: pageTitleSize, fontWeight: FontWeight.w500),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: lightColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                  '''This feature detects if athletes recorded activities together,if they have, the activities are grouped and displayed according to the options below.''',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: drawerMenuItemSize,
                      color: blackColorDark)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Text(
                'Learn More about Group Activities',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: pageIconSize,
                    color: primaryColor),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: RadioListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text('Everyone',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark)),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                        'Your group activities will be visible to anyone on strava.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorLight)),
                  ),
                  value: GroupActivitylist.Everyone,
                  groupValue: _groupActivitylist,
                  onChanged: (GroupActivitylist? value) => setState(() {
                        _groupActivitylist = value;
                        GroupActivity groupActivitydetails = GroupActivity(
                            id: 1,
                            group_activity_selectevalue:
                                GroupActivitylist.Everyone.toString());
                        gpactivitystore.insert(groupActivitydetails);
                        wait();
                      })),
            ),
            const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: RadioListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text('Followers',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark)),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                        'Your group activities will only be visible to athletes who follow you and athletes you follow.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorLight)),
                  ),
                  value: GroupActivitylist.Followers,
                  groupValue: _groupActivitylist,
                  onChanged: (GroupActivitylist? value) => setState(() {
                        _groupActivitylist = value;
                        GroupActivity groupActivitydetails = GroupActivity(
                            id: 1,
                            group_activity_selectevalue:
                                GroupActivitylist.Followers.toString());
                        gpactivitystore.insert(groupActivitydetails);
                        wait();
                      })),
            ),
            const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: RadioListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text('No One',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark)),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                        'Your activities will not be displayed as part of group activities.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorLight)),
                  ),
                  value: GroupActivitylist.NoOne,
                  groupValue: _groupActivitylist,
                  onChanged: (GroupActivitylist? value) => setState(() {
                        _groupActivitylist = value;
                        GroupActivity groupActivitydetails = GroupActivity(
                            id: 1,
                            group_activity_selectevalue:
                                GroupActivitylist.NoOne.toString());
                        gpactivitystore.insert(groupActivitydetails);
                        wait();
                      })),
            ),
            const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
          ],
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
                  SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Please wait...',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark))
                ],
              ),
            ),
          );
        });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
