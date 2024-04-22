import 'package:anytimeworkout/isar/contact_access/access.dart';
import 'package:anytimeworkout/isar/contact_access/operation.dart' as access_store;
import 'package:flutter/material.dart';



class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  access_store.AccessOperation accessstore = access_store.AccessOperation();
  bool enabled = false;
  getaccessvalue() async {
    List<Access> getvalue = await accessstore.getaccessvalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        enabled = (getvalue.first.accessvalue == false) ? false : true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getaccessvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange.shade900,
            title: const Text('Contacts Access',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 10, 10, 0),
                child: Text(
                  '''When permission is granted,Strava stores and periodically syncs to you address book to make it easy for you to find your friends.If you choose to remove this access we will stop using your address book information to connect you with friends and suggest that you follow them on Strava.Removing access will not affect your Beacon settings.''',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: CheckboxListTile(
                  activeColor: Colors.orange.shade900,
                  title: const Text(
                    'Contact Sync Enabled',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: enabled,
                  onChanged: (value) {
                    setState(() {
                      enabled = value!;
                      Access getvalue = Access(id: 1, accessvalue: enabled);
                      accessstore.insert(getvalue);
                      if (enabled == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Contacts successfully removed',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.blue.shade800,
                            duration: const Duration(seconds: 2),
                            dismissDirection: DismissDirection.up,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height - 120,
                                left: 0,
                                right: 0),
                          ),
                        );
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
