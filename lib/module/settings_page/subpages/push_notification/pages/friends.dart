import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/divider.dart';
import 'package:flutter/material.dart';

import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool friends_join = false;
  bool new_followers = false;
  bool frnds_activities = false;
  bool suggested_frnds = false;
  bool segmemnts_routes = false;
  bool videos = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  List<String> friends = [];
  getfriendsvalue() async {
    List<NotificationPush> getvalue = await operationstore.getfriendsvalue();
    if (getvalue.isNotEmpty) {
      for (var item in getvalue) {
        setState(() {
          friends = item.friends!;
        });
        setState(() {
          if (friends.contains('Friend Joins')) {
            friends_join = true;
          }
          if (friends.contains('New Follower')) {
            new_followers = true;
          }
          if (friends.contains('''Friend's Activities''')) {
            frnds_activities = true;
          }
          if (friends.contains('Suggested Friend')) {
            suggested_frnds = true;
          }
          if (friends.contains('Segments and Routes')) {
            segmemnts_routes = true;
          }
          if (friends.contains('Videos')) {
            videos = true;
          }
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfriendsvalue();
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
              'Friends',
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
                  'Friend Joins',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone I know joins strava',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: friends_join,
                onChanged: (value) {
                  setState(() {
                    friends_join = value!;
                    if (friends_join == true) {
                      var tempfriends = List<String>.from(friends);
                      tempfriends.add('Friend Joins');
                      friends = tempfriends;
                    } else if (friends_join == false) {
                      if (friends.contains('Friend Joins')) {
                        var tempfriends = List<String>.from(friends);
                        tempfriends.remove('Friend Joins');
                        friends = tempfriends;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 2, friends: friends);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'New Follower',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone follows me on strava',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: new_followers,
                onChanged: (value) {
                  setState(() {
                    new_followers = value!;
                    if (new_followers == true) {
                      var tempfriends = List<String>.from(friends);
                      tempfriends.add('New Follower');
                      friends = tempfriends;
                    } else if (new_followers == false) {
                      if (friends.contains('New Follower')) {
                        var tempfriends = List<String>.from(friends);
                        tempfriends.remove('New Follower');
                        friends = tempfriends;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 2, friends: friends);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  '''Friend's Activities''',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  '''Notify me when my friends post interesting activities, and when friends I've favorited post activities''',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: frnds_activities,
                onChanged: (value) {
                  setState(() {
                    frnds_activities = value!;
                    if (frnds_activities == true) {
                      var tempfriends = List<String>.from(friends);
                      tempfriends.add('''Friend's Activities''');
                      friends = tempfriends;
                    } else if (frnds_activities == false) {
                      if (friends.contains('''Friend's Activities''')) {
                        var tempfriends = List<String>.from(friends);
                        tempfriends.remove('''Friend's Activities''');
                        friends = tempfriends;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 2, friends: friends);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Suggested Friend',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me to suggest friend to follow',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: suggested_frnds,
                onChanged: (value) {
                  setState(() {
                    suggested_frnds = value!;
                    if (suggested_frnds == true) {
                      var tempfriends = List<String>.from(friends);
                      tempfriends.add('Suggested Friend');
                      friends = tempfriends;
                    } else if (suggested_frnds == false) {
                      if (friends.contains('Suggested Friend')) {
                        var tempfriends = List<String>.from(friends);
                        tempfriends.remove('Suggested Friend');
                        friends = tempfriends;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 2, friends: friends);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Segments and Routes',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone shares a segment or route with me on strava.',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: segmemnts_routes,
                onChanged: (value) {
                  setState(() {
                    segmemnts_routes = value!;
                    if (segmemnts_routes == true) {
                      var tempfriends = List<String>.from(friends);
                      tempfriends.add('Segments and Routes');
                      friends = tempfriends;
                    } else if (segmemnts_routes == false) {
                      if (friends.contains('Segments and Routes')) {
                        var tempfriends = List<String>.from(friends);
                        tempfriends.remove('Segments and Routes');
                        friends = tempfriends;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 2, friends: friends);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Videos',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  '''Notify me when someone I'm following has uploaded a video''',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: videos,
                onChanged: (value) {
                  setState(() {
                    videos = value!;
                    if (videos == true) {
                      var tempfriends = List<String>.from(friends);
                      tempfriends.add('Videos');
                      friends = tempfriends;
                    } else if (videos == false) {
                      if (friends.contains('Videos')) {
                        var tempfriends = List<String>.from(friends);
                        tempfriends.remove('Videos');
                        friends = tempfriends;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 2, friends: friends);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          const SizedBox(
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
