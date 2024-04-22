import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/activities/activities.dart';
import 'package:anytimeworkout/isar/activities/activityoperation.dart'
    as activity_store;
import 'package:anytimeworkout/isar/flybys/flybys.dart';
import 'package:anytimeworkout/isar/flybys/flybysoperation.dart'
    as flybys_store;
import 'package:anytimeworkout/isar/group_activities/groupactivity.dart';
import 'package:anytimeworkout/isar/group_activities/groupactivityoperation.dart'
    as gp_activity_store;
import 'package:anytimeworkout/isar/local_legends/local.dart';
import 'package:anytimeworkout/isar/local_legends/localoperation.dart'
    as local_store;
import 'package:anytimeworkout/isar/mentions/mention.dart';
import 'package:anytimeworkout/isar/mentions/mentionoperation.dart'
    as mention_store;
import 'package:anytimeworkout/isar/profile/profile.dart';
import 'package:anytimeworkout/isar/profile/profileoperation.dart'
    as profile_store;
import 'package:anytimeworkout/module/settings_page/pages/settingPage.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/aggregated_data.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/edit_activities.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/map_visibility.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/messaging.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/personal_information.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/public_photos.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/where_you_appear/activities.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/where_you_appear/flybys.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/where_you_appear/group_activity.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/where_you_appear/local_legends.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/where_you_appear/mentions.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/where_you_appear/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyControlPage extends StatefulWidget {
  PrivacyControlPage({super.key});

  @override
  State<PrivacyControlPage> createState() => _PrivacyControlPageState();
}

class _PrivacyControlPageState extends State<PrivacyControlPage> {
  String profileStore = '';
  String activityStore = '';
  String gpActivityStore = '';
  String flybysStore = '';
  String localStore = '';
  String mentionStore = '';
  profile_store.ProfileOperation profilestore =
      profile_store.ProfileOperation();
  activity_store.ActivityOperation activitystore =
      activity_store.ActivityOperation();
  gp_activity_store.GroupActivityOperation gpactivitystore =
      gp_activity_store.GroupActivityOperation();
  flybys_store.FlybysOperation flybysstore = flybys_store.FlybysOperation();
  local_store.LocalOperation localstore = local_store.LocalOperation();
  mention_store.MentionOperation mentionstore =
      mention_store.MentionOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: lightColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Privacy Controls',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: lightColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 20, 0, 0),
                child: Text(
                  'Where You Appear',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile Page',
                          style: TextStyle(
                              fontSize: 15,
                              color: blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            'Who can see:$profileStore',
                            style: const TextStyle(
                                fontSize: 13,
                                color: blackColorLight,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ActivitesPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                          'Activities',
                          style: TextStyle(
                              fontSize: 15,
                              color: blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Text(
                          'Who can see:$activityStore',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: blackColorLight),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GroupActivityPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                          'Group Activities',
                          style: TextStyle(
                              fontSize: 15,
                              color: blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Text(
                          'Who can see:$gpActivityStore',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: blackColorLight),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FlybysPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                          'Flybys',
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Text(
                          'who can see:$flybysStore',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: blackColorLight),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocalLegendsPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                          'Local Legends',
                          style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Text(
                          'who can see:$localStore',
                          style: const TextStyle(
                              fontSize: 13,
                              color: blackColorLight,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const MentionPage())));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text(
                          'Mentions',
                          style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Text(
                          'who can mention:$mentionStore',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: blackColorLight),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 0.2,
                color: dividerColor,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 10, 0, 0),
                child: Text(
                  'Additional Controls',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MessagePage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                        child: Text(
                          'Messaging',
                          style: TextStyle(
                              fontSize: 15,
                              color: blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const MapVisibilityPage()));
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: const Padding(
              //       padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
              //       child: Text(
              //         'Map visibility',
              //         style: TextStyle(
              //             fontSize: 15,
              //             color: blackColor,
              //             fontWeight: FontWeight.w500),
              //       ),
              //     ),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const DataUsagePage()));
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: const Padding(
              //       padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
              //       child: Text(
              //         'Agreegated Data Usage',
              //         style: TextStyle(
              //             fontSize: 15,
              //             color: blackColor,
              //             fontWeight: FontWeight.w500),
              //       ),
              //     ),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const PublicPhotoPage()));
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: const Padding(
              //       padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
              //       child: Text(
              //         'Public Photos on Routes',
              //         style: TextStyle(
              //             fontSize: 15,
              //             color: blackColor,
              //             fontWeight: FontWeight.w500),
              //       ),
              //     ),
              //   ),
              // ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditActivitiesPage()));
                  wait();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Text(
                      'Edit Past Activities',
                      style: TextStyle(
                          fontSize: 15,
                          color: blackColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PersonalInformationPage()));
                },
                child: Container(
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Text(
                      'Do Not Share My Personal Information',
                      style: TextStyle(
                          fontSize: 15,
                          color: blackColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  getdata() async {
    // for profile
    List<Profile> store = await profilestore.getProfile();
    // for activity
    List<Activity> storeactivityvalues = await activitystore.getactivity();
    // // for gp_activity
    List<GroupActivity> getgroupactivityvalue =
        await gpactivitystore.getgroupactivity();
    // // for flybys
    List<Flybys> getflybysvalue = await flybysstore.getflybysvalue();
    // for local_legends
    List<Local> getlocalvalue = await localstore.getlocaldata();
    //for mention
    List<Mention> getmentionvalue = await mentionstore.getmentionsvalue();
    //for profile
    setState(() {
      profileStore = (store.first.selectedValue == "radiooptions.Everyone"
          ? "Everyone"
          : "Followers");
      print(profileStore);
    });
    // for activity
    setState(() {
      if (storeactivityvalues.first.Activityselectvalue ==
          "Radiolists.Everyone") {
        activityStore = "Everyone";
      } else if (storeactivityvalues.first.Activityselectvalue ==
          "Radiolists.Followers") {
        activityStore = "Followers";
      } else {
        activityStore = "OnlyYou";
      }
    });
    // // for gp_activity
    setState(() {
      if (getgroupactivityvalue.first.group_activity_selectevalue ==
          "GroupActivitylist.Everyone") {
        gpActivityStore = "Everyone";
      } else if (getgroupactivityvalue.first.group_activity_selectevalue ==
          "GroupActivitylist.Followers") {
        gpActivityStore = "Followers";
      } else {
        gpActivityStore = "NoOne";
      }
    });
    // //for flybys
    setState(() {
      flybysStore =
          (getflybysvalue.first.flybysselectvalue == "Flybyslist.Everyone")
              ? "Everyone"
              : "NoOne";
    });
    // for local_legends
    if (getflybysvalue.isNotEmpty) {
      setState(() {
        localStore =
            (getlocalvalue.first.localselectvalue == "Locallegndslist.Everyone")
                ? "Everyone"
                : "NoOne";
      });
    }
    //for mention
    if (getmentionvalue.isNotEmpty) {
      setState(() {
        if (getmentionvalue.first.mentionselectvalue ==
            "Mentionlist.Everyone") {
          mentionStore = "Everyone";
        } else if (getmentionvalue.first.mentionselectvalue ==
            "Mentionlist.Followers") {
          mentionStore = "Followers";
        } else {
          mentionStore = "NoOne";
        }
      });
    }
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
                  CircularProgressIndicator(
                    color: Colors.orange.shade900,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text('Please wait...')
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
