import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/local_legends/local.dart';
import 'package:anytimeworkout/isar/local_legends/localoperation.dart'
    as local_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

enum Locallegndslist { Everyone, NoOne }

class LocalLegendsPage extends StatefulWidget {
  const LocalLegendsPage({super.key});

  @override
  State<LocalLegendsPage> createState() => _LocalLegendsPageState();
}

class _LocalLegendsPageState extends State<LocalLegendsPage> {
  Locallegndslist? _locallegendslist = Locallegndslist.Everyone;
  local_store.LocalOperation localstore = local_store.LocalOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    List<Local> getlocalvalue = await localstore.getlocaldata();
    if (getlocalvalue.isNotEmpty) {
      setState(() {
        _locallegendslist =
            (getlocalvalue.first.localselectvalue == "Locallegndslist.Everyone")
                ? Locallegndslist.Everyone
                : Locallegndslist.NoOne;
        print(_locallegendslist);
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
                      builder: ((context) => PrivacyControlPage())));
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text('Local Legends',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: pageTitleSize,
                color: lightColor)),
        systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: lightColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: lightColor,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
              child: Text(
                '''The Local Legend's name and efforts are visible to everyone.If you're not the Local Legend(LCL), ypur effort count and histogram placement are only visible to you.''',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: drawerMenuItemSize,
                    color: blackColorDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Text('Learn More about Local Legends',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: primaryColor)),
            ),
           const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
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
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                    '''Only activities marked as visible to 'Everyone' will be counted towards Local Legends.If you are the Local Legend your name and achivement will be visible to everyone.If you're not the Local Legend, your effort count and histogram placement are only visible to you''',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
              ),
              value: Locallegndslist.Everyone,
              groupValue: _locallegendslist,
              onChanged: ((Locallegndslist? value) => setState(() {
                    _locallegendslist = value;
                    Local localdetails = Local(
                        id: 1,
                        localselectvalue: Locallegndslist.Everyone.toString());
                    localstore.insert(localdetails);
                    wait();
                  })),
            ),
            const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
            RadioListTile(
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
                    '''Your activities will not be counted towards a Local Legend achievement.If you'd like to join again in the future,only activities from the time you join will be counted.''',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight)),
              ),
              value: Locallegndslist.NoOne,
              groupValue: _locallegendslist,
              onChanged: (Locallegndslist? value) => setState(() {
                _locallegendslist = value;
                Local localdetails = Local(
                    id: 1, localselectvalue: Locallegndslist.NoOne.toString());
                localstore.insert(localdetails);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          actions: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Leave Local Legends',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: pageIconSize,
                                        color: blackColorDark),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      '''If you choose to leave,your activities will not be counted towards a Local Legend achievement.If you'd like to join again the future,only activities from the day you join will be counted.Are you sure you want to leave?''',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: pageIconSize,
                                          color: blackColorLight)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: Text('Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: pageIconSize,
                                                color: primaryColor))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          wait();
                                        },
                                        child: Text('Yes,Leave',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: pageIconSize,
                                                color: primaryColor)))
                                  ],
                                )
                              ],
                            )
                          ],
                        ));
              }),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 30,
            )
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
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                   Text('Please wait...',
                   style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: primaryColor))
                ],
              ),
            ),
          );
        });
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
