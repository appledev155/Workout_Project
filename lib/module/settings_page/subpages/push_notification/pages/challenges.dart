import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/divider.dart';
import 'package:flutter/material.dart';

import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;

import '../../../../../config/app_colors.dart';
import '../../../../../config/styles.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  bool challenge_progress = false;
  bool challenge_rewards = false;
  bool challenge_invites = false;
  bool group = false;
  bool gp_challenge_leaderboard = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  List<String> challenges = [];
  getchallengesvalue() async {
    List<NotificationPush> getvalue = await operationstore.getchallengesvalue();
    if (getvalue.isNotEmpty) {
      for (var item in getvalue) {
        setState(() {
          challenges = item.challenges!;
        });
        setState(() {
          if (challenges.contains('Challenge Progress')) {
            challenge_progress = true;
          }
          if (challenges.contains('Challenge Rewards')) {
            challenge_rewards = true;
          }
          if (challenges.contains('Challenge Invites')) {
            challenge_invites = true;
          }
          if (challenges.contains('Group Challenge Comments')) {
            group = true;
          }
          if (challenges.contains('Group Challenge Leaderboard Changes')) {
            gp_challenge_leaderboard = true;
          }
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getchallengesvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text(
              'Challenges',
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
                  'Challenge Progress',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  '''Notify me when I've joined,made progress on or completed either a Strava Challenge or Group Challenge''',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: challenge_progress,
                onChanged: (value) {
                  setState(() {
                    challenge_progress = value!;
                    if (challenge_progress == true) {
                      var tempchallenges = List<String>.from(challenges);
                      tempchallenges.add('Challenge Progress');
                      challenges = tempchallenges;
                    } else if (challenge_progress == false) {
                      if (challenges.contains('Challenge Progress')) {
                        var tempchallenges = List<String>.from(challenges);
                        tempchallenges.remove('Challenge Progress');
                        challenges = tempchallenges;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 3, challenges: challenges);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Challenge Rewards',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when I complete a challenge that has a reward,donation,or an opportunity to learn more',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: challenge_rewards,
                onChanged: (value) {
                  setState(() {
                    challenge_rewards = value!;
                    if (challenge_rewards == true) {
                      var tempchallenges = List<String>.from(challenges);
                      tempchallenges.add('Challenge Rewards');
                      challenges = tempchallenges;
                    } else if (challenge_rewards == false) {
                      if (challenges.contains('Challenge Rewards')) {
                        var tempchallenges = List<String>.from(challenges);
                        tempchallenges.remove('Challenge Rewards');
                        challenges = tempchallenges;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 3, challenges: challenges);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Challenge Invites',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone invites me to either a Strava Challenge or Group Challenge',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: challenge_invites,
                onChanged: (value) {
                  setState(() {
                    challenge_invites = value!;
                    if (challenge_invites == true) {
                      var tempchallenges = List<String>.from(challenges);
                      tempchallenges.add('Challenge Invites');
                      challenges = tempchallenges;
                    } else if (challenge_invites == false) {
                      if (challenges.contains('Challenge Invites')) {
                        var tempchallenges = List<String>.from(challenges);
                        tempchallenges.remove('Challenge Invites');
                        challenges = tempchallenges;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 3, challenges: challenges);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Group Challenge Comments',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone comments on a Group Challenge',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: group,
                onChanged: (value) {
                  setState(() {
                    group = value!;
                    if (group == true) {
                      var tempchallenges = List<String>.from(challenges);
                      tempchallenges.add('Group Challenge Comments');
                      challenges = tempchallenges;
                    } else if (group == false) {
                      if (challenges.contains('Group Challenge Comments')) {
                        var tempchallenges = List<String>.from(challenges);
                        tempchallenges.remove('Group Challenge Comments');
                        challenges = tempchallenges;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 3, challenges: challenges);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Group Challenge Leaderboard Changes',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone passes me on a Group Challenge leaderboard',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: gp_challenge_leaderboard,
                onChanged: (value) {
                  setState(() {
                    gp_challenge_leaderboard = value!;
                    if (gp_challenge_leaderboard == true) {
                      var tempchallenges = List<String>.from(challenges);
                      tempchallenges.add('Group Challenge Leaderboard Changes');
                      challenges = tempchallenges;
                    } else if (gp_challenge_leaderboard == false) {
                      if (challenges
                          .contains('Group Challenge Leaderboard Changes')) {
                        var tempchallenges = List<String>.from(challenges);
                        tempchallenges
                            .remove('Group Challenge Leaderboard Changes');
                        challenges = tempchallenges;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 3, challenges: challenges);
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
