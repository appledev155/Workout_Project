import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/divider.dart';
import 'package:flutter/material.dart';

import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  bool club_invitation = false;
  bool new_post = false;
  bool club_event = false;
  bool join_request = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  List<String> clubs = [];
  getclubsvalue() async {
    List<NotificationPush> getvalue = await operationstore.getclubsvalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        for (var item in getvalue) {
          clubs = item.clubs!;
        }
      });
      setState(() {
        if (clubs.contains('Club Invitation')) {
          club_invitation = true;
        }
        if (clubs.contains('New Post')) {
          new_post = true;
        }
        if (clubs.contains('New Club Event')) {
          club_event = true;
        }
        if (clubs.contains('Join Request')) {
          join_request = true;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getclubsvalue();
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
              'Clubs',
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
                  'Club Invitation',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when a friend invites me to join a club',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: club_invitation,
                onChanged: (value) {
                  setState(() {
                    club_invitation = value!;
                    if (club_invitation == true) {
                      var tempclubs = List<String>.from(clubs);
                      tempclubs.add('Club Invitation');
                      clubs = tempclubs;
                    } else if (club_invitation == false) {
                      if (clubs.contains('Club Invitation')) {
                        var tempclubs = List<String>.from(clubs);
                        tempclubs.remove('Club Invitation');
                        clubs = tempclubs;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 4, clubs: clubs);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'New Post',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when a post is added in one of my clubs',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: new_post,
                onChanged: (value) {
                  setState(() {
                    new_post = value!;
                    if (new_post == true) {
                      var tempclubs = List<String>.from(clubs);
                      tempclubs.add('New Post');
                      clubs = tempclubs;
                    } else if (new_post == false) {
                      if (clubs.contains('New Post')) {
                        var tempclubs = List<String>.from(clubs);
                        tempclubs.remove('New Post');
                        clubs = tempclubs;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 4, clubs: clubs);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'New Club Event',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when an event is added in one of my clubs',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: club_event,
                onChanged: (value) {
                  setState(() {
                    club_event = value!;
                    if (club_event == true) {
                      var tempclubs = List<String>.from(clubs);
                      tempclubs.add('New Club Event');
                      clubs = tempclubs;
                    } else if (club_event == false) {
                      if (clubs.contains('New Club Event')) {
                        var tempclubs = List<String>.from(clubs);
                        tempclubs.remove('New Club Event');
                        clubs = tempclubs;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 4, clubs: clubs);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Join Request',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone requests to join one of my clubs',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: join_request,
                onChanged: (value) {
                  setState(() {
                    join_request = value!;
                    if (join_request == true) {
                      var tempclubs = List<String>.from(clubs);
                      tempclubs.add('Join Request');
                      clubs = tempclubs;
                    } else if (join_request == false) {
                      if (clubs.contains('Join Request')) {
                        var tempclubs = List<String>.from(clubs);
                        tempclubs.remove('Join Request');
                        clubs = tempclubs;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 4, clubs: clubs);
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
