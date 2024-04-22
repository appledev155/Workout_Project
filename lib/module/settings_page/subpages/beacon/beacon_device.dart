import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/settings_page/subpages/link_other_device/other_services.dart';
import 'package:flutter/material.dart';

class BeaconDevicepage extends StatefulWidget {
  BeaconDevicepage({super.key});

  @override
  State<BeaconDevicepage> createState() => _BeaconDevicepageState();
}

class _BeaconDevicepageState extends State<BeaconDevicepage> {
  bool beacon_device = false;
  bool _isEditingText = false;

  TextEditingController _editingController = TextEditingController();
  String initialText =
      '''Here's my live location for my next activity! Follow along on Strava.''';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _editingController.dispose();
  }

  void showdialogbox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Connect to Strava and Garmin',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '''You must link your Garmin Connect account with Strava to use Beacon on your Garmin.''',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Not Now',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: primaryColor),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => OtherServicePage(
                                        beacon: true,
                                      ))));
                        },
                        child: const Text(
                          'Link accounts',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: primaryColor),
                        )),
                  ],
                )
              ],
            ));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              cursorColor:primaryColor,
              controller: _editingController,
              onSubmitted: (newValue) {
                setState(() {
                  initialText = newValue;
                  _isEditingText = false;
                });
              },
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
                )
              ),
              autofocus: true,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              if (_isEditingText)
                TextButton(
                  child: const Text(
                    'Ok',
                    style: TextStyle(color:primaryColor),
                  ),
                  onPressed: () {
                    setState(() {
                      initialText = _editingController.text;
                      _isEditingText = false;
                      Navigator.pop(context);
                    });
                  },
                ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.grey,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
              child: Text(
                'Beacon for Devices',
                style: TextStyle(color: primaryColor),
              ),
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: SwitchListTile(
                  title: const Text(
                    'Garmin',
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: const Text(
                    'Share your location from your Garmin device.',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: beacon_device,
                  onChanged: (value) {
                    setState(() {
                      showdialogbox();
                      // beacon_device = value;
                    });
                  }),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
              child: Text(
                'Message',
                style: TextStyle(color:primaryColor,fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
              child: Container(
                  child: TextButton(
                onPressed: () {
                  setState(() {
                    _isEditingText = true;
                    _displayTextInputDialog(context);
                  });
                },
                child: Text(
                  initialText,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal,fontSize: 16),
                ),
              )),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
              child: Text(
                'Contacts',
                style: TextStyle(color:primaryColor,fontSize: 16),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(primaryColor),
                          side: MaterialStatePropertyAll(
                              BorderSide(color: primaryColor))),
                      onPressed: () {},
                      child: const Text(
                        'Add Safety Contacts',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:lightColor),
                      ),
                      ),
                      ),
            ),
            const Divider(
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
