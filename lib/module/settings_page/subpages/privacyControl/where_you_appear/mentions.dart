import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/mentions/mention.dart';
import 'package:anytimeworkout/isar/mentions/mentionoperation.dart'
    as mention_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Mentionlist { Everyone, Followers, NoOne }

class MentionPage extends StatefulWidget {
  const MentionPage({super.key});

  @override
  State<MentionPage> createState() => _MentionPageState();
}

class _MentionPageState extends State<MentionPage> {
  Mentionlist? _mentionlist = Mentionlist.Everyone;
  mention_store.MentionOperation mentionstore =
      mention_store.MentionOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    List<Mention> getmentionvalue = await mentionstore.getmentionsvalue();
    if (getmentionvalue.isNotEmpty) {
      setState(() {
        if (getmentionvalue.first.mentionselectvalue ==
            "Mentionlist.Everyone") {
          _mentionlist = Mentionlist.Everyone;
        } else if (getmentionvalue.first.mentionselectvalue ==
            "Mentionlist.Followers") {
          _mentionlist = Mentionlist.Followers;
        } else {
          _mentionlist = Mentionlist.NoOne;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => PrivacyControlPage())));
            },
            icon: const Icon(Icons.arrow_back)),
        title:  Text(
          'Mentions',
           style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: pageTitleSize,
                    color: lightColor),
        ),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                'Choose who can @mention you and tag your account.',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: pageIconSize,
                    color: blackColorDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
              child: Text(
                'Learn More about Mentions.',
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
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    'Everyone',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      'There are no restrictions on who can mention you',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight),
                    ),
                  ),
                  value: Mentionlist.Everyone,
                  groupValue: _mentionlist,
                  onChanged: (Mentionlist? value) => setState(() {
                        _mentionlist = value;
                        Mention getmentionvalue = Mention(
                            id: 1,
                            mentionselectvalue: Mentionlist.Everyone.toString());
                        mentionstore.insert(getmentionvalue);
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
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    'Followers',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      'Only your followers will be able to mention you',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorLight),
                    ),
                  ),
                  value: Mentionlist.Followers,
                  groupValue: _mentionlist,
                  onChanged: ((Mentionlist? value) => setState(() {
                        _mentionlist = value;
                        Mention getmentionvalue = Mention(
                            id: 1,
                            mentionselectvalue: Mentionlist.Followers.toString());
                        mentionstore.insert(getmentionvalue);
                        wait();
                      }))),
            ),
             const Divider(
              height: 1,
              thickness: 0.9,
              color: dividerColor,
            ),
            Padding(
             padding: const EdgeInsets.only(top: 20,bottom: 10),
              child: RadioListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    'No One',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  ),
                  subtitle: Text(
                    'No one will be able to mention you',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: pageIconSize,
                        color: blackColorLight),
                  ),
                  value: Mentionlist.NoOne,
                  groupValue: _mentionlist,
                  onChanged: (Mentionlist? value) => setState(() {
                        _mentionlist = value;
                        Mention getmentionvalue = Mention(
                            id: 1,
                            mentionselectvalue: Mentionlist.NoOne.toString());
                        mentionstore.insert(getmentionvalue);
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
                          color: blackColorDark),)
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
