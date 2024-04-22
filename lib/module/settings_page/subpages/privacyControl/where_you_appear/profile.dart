import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/profile/profile.dart';
import 'package:anytimeworkout/isar/profile/profileoperation.dart'
    as profile_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

enum radiooptions { Everyone, Followers, OnlyYou }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  radiooptions? _radiooptions = radiooptions.Everyone;
  profile_store.ProfileOperation profilestore =
      profile_store.ProfileOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    List<Profile> store = await profilestore.getProfile();
    // print(store);
    if (store.isNotEmpty) {
      setState(() {
        _radiooptions = (store.first.selectedValue == "radiooptions.Everyone")
            ? radiooptions.Everyone
            : radiooptions.Followers;
        //  print(_radiooptions);
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
          'Profile Page',
          style: TextStyle(fontSize: pageTitleSize, fontWeight: FontWeight.w400),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                  '''Your profile page displays information about you,such as your name,activities,followers,photos, and stats.Parts of your profile page will always be publicly available. ''',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('Learn More about Profile Pages',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: primaryColor)),
            ),
            const Divider(
              height: 50,
              thickness: 0.5,
              color: Colors.grey,
            ),
            RadioListTile(
                activeColor: primaryColor,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text('Everyone',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                      '''Anyone on strava can search for and view your complete profile page and activity summaries, as well as follow you. Anyone on the web can search for and view certain profile information.''',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight)),
                ),
                value: radiooptions.Everyone,
                groupValue: _radiooptions,
                onChanged: (radiooptions? value) {
                  setState(() {
                    _radiooptions = value;
                    Profile profiledetails = Profile(
                        id: 1, selectedValue: radiooptions.Everyone.toString());
                    profilestore.insert(profiledetails);
                    wait();
                  });
                }),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
            RadioListTile(
                activeColor: primaryColor,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text('Followers',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark)),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                      '''Members who follow you can see your complete profile page.Anyone can search for and view certain profile information,and you can approve who follows you.''',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight)),
                ),
                value: radiooptions.Followers,
                groupValue: _radiooptions,
                onChanged: (radiooptions? value) => setState(() {
                      _radiooptions = value;
                      Profile profiledetails = Profile(
                          id: 1,
                          selectedValue: radiooptions.Followers.toString());
                      profilestore.insert(profiledetails);
                      wait();
                    })),
            const SizedBox(
              height: 15,
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
