import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/email_notification/operation.dart' as updation_store;
import 'package:anytimeworkout/isar/email_notification/updation.dart';
import 'package:flutter/material.dart';

class EmailNotificationPage extends StatefulWidget {
  const EmailNotificationPage({super.key});

  @override
  State<EmailNotificationPage> createState() => _EmailNotificationPageState();
}

class _EmailNotificationPageState extends State<EmailNotificationPage> {
  updation_store.updation updationstore = updation_store.updation();
  String _updationvalue = '';
  getUpdationValue() async {
    List<Updation> getvalue = await updationstore.getupdationvalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        _updationvalue =
            (getvalue.first.updationselectedvalue == "On") ? "On" : "Off";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpdationValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        title:  Text(
          'Email Notifications',
          style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageTitleSize,
                          color: lightColor),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
              child: Text(
                '''Once in a while, we'd like to email you quick updates about new features,personalized data visualizations or promotions and offers from Strava and its partners that we think you'll appreciate. And it's just some fun between us - we don't share or sell your contact information and you can change these settings at any time.''',
                 style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight)
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: TextButton(
                onPressed: () {
                  dialogbox();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      'Strava Updates',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight)
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      _updationvalue,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void dialogbox() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              actions: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 130, 0),
                  child: Text(
                    'Strava Updates',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                RadioListTile(
                    activeColor: Colors.orange.shade900,
                    title: const Text('On'),
                    value: 'On',
                    groupValue: _updationvalue,
                    onChanged: (String? value) {
                      setState(() {
                        _updationvalue = value!;
                        Navigator.pop(context);
                        Updation getupdationvalue = Updation(
                            id: 1, updationselectedvalue: _updationvalue);
                        updationstore.insert(getupdationvalue);
                      });
                    }),
                RadioListTile(
                    activeColor: Colors.orange.shade900,
                    title: const Text('Off'),
                    value: 'Off',
                    groupValue: _updationvalue,
                    onChanged: (String? value) {
                      setState(() {
                        _updationvalue = value!;
                        Navigator.pop(context);
                        Updation getupdationvalue = Updation(
                            id: 1, updationselectedvalue: _updationvalue);
                        updationstore.insert(getupdationvalue);
                      });
                    }),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.orange.shade800),
                    ))
              ],
            ));
  }
}
