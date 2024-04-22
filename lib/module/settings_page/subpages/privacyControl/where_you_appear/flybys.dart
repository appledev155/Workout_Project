import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/isar/flybys/flybys.dart';
import 'package:anytimeworkout/isar/flybys/flybysoperation.dart'
    as flybys_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../config/styles.dart';

enum Flybyslist { Everyone, NoOne }

class FlybysPage extends StatefulWidget {
  const FlybysPage({super.key});

  @override
  State<FlybysPage> createState() => _FlybysPageState();
}

class _FlybysPageState extends State<FlybysPage> {
  Flybyslist? _flybyslist = Flybyslist.Everyone;
  flybys_store.FlybysOperation flybysstore = flybys_store.FlybysOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    List<Flybys> getflybysvalue = await flybysstore.getflybysvalue();
    if (getflybysvalue.isNotEmpty) {
      setState(() {
        _flybyslist =
            (getflybysvalue.first.flybysselectvalue == "Flybyslist.Everyone")
                ? Flybyslist.Everyone
                : Flybyslist.NoOne;
        print(_flybyslist);
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
        title: Text(
          'Flybys',
          style:
              TextStyle(fontSize: pageTitleSize, fontWeight: FontWeight.w500),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: Text(
                  '''Flybys provide in-depth activity playbacks to anyone on strava or the web.Flybys aloow you to rewatch any activity minute by minute, and see athletes who were nearby and where you crossed paths.''',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Text(
                'Learn More about Flyby',
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
              padding: const EdgeInsets.only(top: 20,bottom: 10),
              child: RadioListTile(
                  activeColor:primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title:  Text('Everyone',
                    style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorDark)),
                  subtitle:  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                        '''Your activities are accessible to you and anyone on the web using Flybys.Only your activities marked as visible to 'Everyone' will be displayed in Flybys.''',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorLight)),
                  ),
                  value: Flybyslist.Everyone,
                  groupValue: _flybyslist,
                  onChanged: (Flybyslist? value) => setState(() {
                        _flybyslist = value;
                        Flybys flybysdetails = Flybys(
                            id: 1,
                            flybysselectvalue: Flybyslist.Everyone.toString());
                        flybysstore.insert(flybysdetails);
                        wait();
                      })),
            ),
           const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
            Padding(
             padding: const EdgeInsets.only(top: 20,bottom: 10),
              child: RadioListTile(
                  activeColor:primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title:  Text('No One',
                    style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorDark)),
                  subtitle:  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                        '''Your activities will not be visioble on Flybys to you or to anyone else.''',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorLight)),
                  ),
                  value: Flybyslist.NoOne,
                  groupValue: _flybyslist,
                  onChanged: (Flybyslist? value) => setState(() {
                        _flybyslist = value;
                        Flybys flybysdetails = Flybys(
                            id: 1,
                            flybysselectvalue: Flybyslist.NoOne.toString());
                        flybysstore.insert(flybysdetails);
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
                  const SizedBox(
                    width: 20,
                  ),
                  const CircularProgressIndicator(
                    color:primaryColor,
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
