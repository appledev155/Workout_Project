import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/divider.dart';
import 'package:flutter/material.dart';

import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;

class Eventpage extends StatefulWidget {
  const Eventpage({super.key});

  @override
  State<Eventpage> createState() => _EventpageState();
}

class _EventpageState extends State<Eventpage> {
  bool event_invitation = false;
  bool event_reminder = false;
  bool event_change = false;
  bool event_RSVP = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  List<String> events = [];
  geteventsvalue() async {
    List<NotificationPush> getvalue = await operationstore.geteventsvalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        for (var item in getvalue) {
          events = item.events!;
        }
      });
      setState(() {
        if (events.contains('Event Invitation')) {
          event_invitation = true;
        }
        if (events.contains('Event Reminder')) {
          event_reminder = true;
        }
        if (events.contains('Event Change')) {
          event_change = true;
        }
        if (events.contains('Event RSVP')) {
          event_RSVP = true;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geteventsvalue();
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
              'Events',
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
                  'Event Invitation',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when a friend invites me to join an event',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: event_invitation,
                onChanged: (value) {
                  setState(() {
                    event_invitation = value!;
                    if (event_invitation == true) {
                      var tempevents = List<String>.from(events);
                      tempevents.add('Event Invitation');
                      events = tempevents;
                    } else if (event_invitation == false) {
                      if (events.contains('Event Invitation')) {
                        var tempevents = List<String>.from(events);
                        tempevents.remove('Event Invitation');
                        events = tempevents;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 5, events: events);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          CheckboxListTile(
              activeColor: primaryColor,
              title: Text(
                'Event Reminder',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: pageIconSize,
                    color: blackColorDark),
              ),
              subtitle: Text(
                'Notify me 24 hours before one of my events',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: pageIconSize,
                    color: blackColorLight),
              ),
              value: event_reminder,
              onChanged: (value) {
                setState(() {
                  event_reminder = value!;
                  if (event_reminder == true) {
                    var tempevents = List<String>.from(events);
                    tempevents.add('Event Reminder');
                    events = tempevents;
                  } else if (event_reminder == false) {
                    if (events.contains('Event Reminder')) {
                      var tempevents = List<String>.from(events);
                      tempevents.remove('Event Reminder');
                      events = tempevents;
                    }
                  }
                  NotificationPush getvalue =
                      NotificationPush(id: 5, events: events);
                  operationstore.insert(getvalue);
                });
              }),
          CheckboxListTile(
              activeColor: primaryColor,
              title: Text(
                'Event Change',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: pageIconSize,
                    color: blackColorDark),
              ),
              subtitle: Text(
                'Notify me when one of my events is changed or canceled',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: pageIconSize,
                    color: blackColorLight),
              ),
              value: event_change,
              onChanged: (value) {
                setState(() {
                  event_change = value!;
                  if (event_change == true) {
                    var tempevents = List<String>.from(events);
                    tempevents.add('Event Change');
                    events = tempevents;
                  } else if (event_change == false) {
                    if (events.contains('Event Change')) {
                      var tempevents = List<String>.from(events);
                      tempevents.remove('Event Change');
                      events = tempevents;
                    }
                  }
                  NotificationPush getvalue =
                      NotificationPush(id: 5, events: events);
                  operationstore.insert(getvalue);
                });
              }),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Event RSVP',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  '''Notify me when someone RSVPs to an event I'm organizing''',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: event_RSVP,
                onChanged: (value) {
                  setState(() {
                    event_RSVP = value!;
                    if (event_RSVP == true) {
                      var tempevents = List<String>.from(events);
                      tempevents.add('Event RSVP');
                      events = tempevents;
                    } else if (event_RSVP == false) {
                      if (events.contains('Event RSVP')) {
                        var tempevents = List<String>.from(events);
                        tempevents.remove('Event RSVP');
                        events = tempevents;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 5, events: events);
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
