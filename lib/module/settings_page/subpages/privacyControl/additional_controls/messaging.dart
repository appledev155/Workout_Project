import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/messaging/message.dart';
import 'package:anytimeworkout/isar/messaging/messageoperation.dart' as message_store;
import 'package:anytimeworkout/isar/messaging_visibility/visibilityoperation.dart' as visible_store;
import 'package:anytimeworkout/isar/messaging_visibility/visible.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';


enum Messagelist { Following, Mutuals, NoOne }

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Messagelist? _messagelist = Messagelist.Following;
  message_store.MessageOperation messagestore =
      message_store.MessageOperation();
  visible_store.VisibilityOperation visiblestore =
      visible_store.VisibilityOperation();
  bool visibility = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    getvisiblevalue();
  }

  getdata() async {
    List<Message> getmessagevalue = await messagestore.getmessagevalue();
    //print(getmessagevalue);
    if (getmessagevalue.isNotEmpty) {
      setState(() {
        if (getmessagevalue.first.messageselectvalue ==
            "Messagelist.Following") {
          _messagelist = Messagelist.Following;
        } else if (getmessagevalue.first.messageselectvalue ==
            "Messagelist.Mutuals") {
          _messagelist = Messagelist.Mutuals;
        } else {
          _messagelist = Messagelist.NoOne;
        }
      });
    }
  }

  getvisiblevalue() async {
    List<Visible> getvalue = await visiblestore.getviisibledata();
    //print(getvalue);
    if (getvalue.isNotEmpty) {
      setState(() {
        visibility =
            (getvalue.first.visibilityselectvalue == false) ? false : true;
        //  print(visibility);
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
                      builder: (context) => PrivacyControlPage()));
                    
            },
            icon: const Icon(Icons.arrow_back)),
        title:  Text(
          'Messaging',
           style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: pageTitleSize,
                      color: lightColor)
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                  '''Messaging lets you chat privately with other people on strava.Choose a setting to decide who can message you.''',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 20),
              child: Text(
                'Learn More about Messaging',
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
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                "Online Status",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SwitchListTile(
                  activeColor:primaryColor,
                  value: visibility,
                  subtitle:  Text(
                      '''Show When You're Online Your online status will be visible in your direct and group messages.''',
                        style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),),
                  onChanged: (value) {
                    setState(() {
                      visibility = value;
                      Visible getdata =
                          Visible(id: 1, visibilityselectvalue: visibility);
                      visiblestore.insert(getdata);
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                "Who Can Message You",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: primaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: RadioListTile(
                  activeColor:primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title:  Text('Following',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),),
                  subtitle:  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child:
                        Text('Anyone you follow will be able to message you.',
                          style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),),
                  ),
                  value: Messagelist.Following,
                  groupValue: _messagelist,
                  onChanged: (Messagelist? value) => setState(() {
                        _messagelist = value;
                        Message messagedetails = Message(
                            id: 1,
                            messageselectvalue:
                                Messagelist.Following.toString());
                        messagestore.insert(messagedetails);
                        wait();
                      })),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: RadioListTile(
                  activeColor:primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title:  Text('Mutuals',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),),
                  subtitle:  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                        'People will only be able to message you if you follow each other.',
                          style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),),
                  ),
                  value: Messagelist.Mutuals,
                  groupValue: _messagelist,
                  onChanged: (Messagelist? value) => setState(() {
                        _messagelist = value;
                        Message messagedetails = Message(
                            id: 1,
                            messageselectvalue: Messagelist.Mutuals.toString());
                        messagestore.insert(messagedetails);
                        wait();
                      })),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: RadioListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title:  Text('No One',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),),
                  
                  subtitle:  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                        '''No one will be able to message you first.Only you will be able to start conversations with other people.''',
                          style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),),
                  ),
                  value: Messagelist.NoOne,
                  groupValue: _messagelist,
                  onChanged: (Messagelist? value) => setState(() {
                        _messagelist = value;
                        Message messagedetails = Message(
                            id: 1,
                            messageselectvalue: Messagelist.NoOne.toString());
                        messagestore.insert(messagedetails);
                        wait();
                      })),
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
