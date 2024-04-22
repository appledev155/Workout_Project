import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/activities/activities.dart';
import 'package:anytimeworkout/isar/activities/activityoperation.dart'
    as activity_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Radiolists { Everyone, Followers, OnlyYou }

class ActivitesPage extends StatefulWidget {
  const ActivitesPage({super.key});

  @override
  State<ActivitesPage> createState() => _ActivitesPageState();
}

class _ActivitesPageState extends State<ActivitesPage> {
  Radiolists? _radiolists = Radiolists.Everyone;
  activity_store.ActivityOperation activitystore =
      activity_store.ActivityOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    List<Activity> storeactivityvalue = await activitystore.getactivity();
    print(storeactivityvalue);
    if (storeactivityvalue.isNotEmpty) {
      setState(() {
        if (storeactivityvalue.first.Activityselectvalue ==
            "Radiolists.Everyone") {
          _radiolists = Radiolists.Everyone;
        } else if (storeactivityvalue.first.Activityselectvalue ==
            "Radiolists.Followers") {
          _radiolists = Radiolists.Followers;
        } else {
          _radiolists = Radiolists.OnlyYou;
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
        title: const Text(
          'Activities',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: lightColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                child: Text(
                    '''Activities are workouts,races,or events you record or upload to strava,What you choose below will be your default,but you can change settings for each individual activity.You will appear in group activities or Flybys unless you adjust those controls.''',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Text(
                  'Learn More about Activities',
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
                padding: const EdgeInsets.only(top: 10,bottom: 20),
                child: RadioListTile(
                    activeColor:primaryColor,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text('Everyone',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorDark)),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        '''Anyone on strava can view your activities.Your activities will be visible on segment and challenge leaderboards, and other strava features.''',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorLight),
                      ),
                    ),
                    value: Radiolists.Everyone,
                    groupValue: _radiolists,
                    onChanged: (Radiolists? value) => setState(() {
                          _radiolists = value;
                          Activity activitydetails = Activity(
                              id: 1,
                              Activityselectvalue:
                                  Radiolists.Everyone.toString());
                          activitystore.insert(activitydetails);
                          wait();
                        })),
              ),
             const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 20),
                child: RadioListTile(
                    activeColor:primaryColor,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title:  Text('Followers',
                     style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                    subtitle:  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        '''Only your followers will be able to see your activity details.Your activities will not appear on segment or challenge leaderboards,and may not count toward some challenge goals.Members who do not follow you may be able to view your activity summaries depending on your other privacy settings.''',
                         style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)
                      ),
                    ),
                    value: Radiolists.Followers,
                    groupValue: _radiolists,
                    onChanged: ((Radiolists? value) => setState(() {
                          _radiolists = value;
                          Activity activitydetails = Activity(
                              id: 1,
                              Activityselectvalue:
                                  Radiolists.Followers.toString());
                          activitystore.insert(activitydetails);
                          wait();
                        }))),
              ),
             const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
              Padding(
               padding: const EdgeInsets.only(top: 10,bottom: 20),
                child: RadioListTile(
                    activeColor: primaryColor,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title:  Text('Only You',
                     style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                    subtitle:  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        '''Your activities are private.Only you can view them.If they count toward a challenge,your followers may see updates on your progress.Np one will see your activity pages,and  your activities won't show up on leaderboards or elsewhere on strava,including group activites or Flybys''',
                         style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight),
                      ),
                    ),
                    value: Radiolists.OnlyYou,
                    groupValue: _radiolists,
                    onChanged: (Radiolists? value) => setState(() {
                          _radiolists = value;
                          Activity activitydetails = Activity(
                              id: 1,
                              Activityselectvalue: Radiolists.OnlyYou.toString());
                          activitystore.insert(activitydetails);
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
                  const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  const SizedBox(
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
