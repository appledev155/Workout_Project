import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/isar/beacon_mobile/beaconlocation.dart';
import 'package:anytimeworkout/isar/beacon_mobile/operation.dart' as operation_store;
import 'package:anytimeworkout/module/settings_page/pages/settingPage.dart';
import 'package:anytimeworkout/module/settings_page/subpages/beacon/beacon_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart';


class BeaconPage extends StatefulWidget {
  BeaconPage({
    super.key,
  });

  @override
  State<BeaconPage> createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  bool beacon_mobile = false;
  operation_store.BeaconOperation operationStore=operation_store.BeaconOperation();
  getlocationselectedvalue()async{
  List<BeaconLocation> getlocationvalue= await operationStore.getlocationselectedvalue();
  if(getlocationvalue.isNotEmpty){
    setState(() {
      beacon_mobile=(getlocationvalue.first.locationselectedvalue==false)?false:true;
    });
  }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocationselectedvalue();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: lightColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.dark),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Beacon',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SettingPage()));
                // if (beacon_mobile == true) {
                //   wait();
                // }
              });
            },
            child: const Text(
              'SAVE',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(17, 15, 10, 0),
              child: Text(
                '''Share a Beacon with up to three safety contacts so they can see your location during your activity.Turn on Beacon to select your contacts.''',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.grey,
            ),
            SwitchListTile(
                activeColor:primaryColor,
                value: beacon_mobile,
                title: const Text(
                  'Beacon For Mobile',
                  style: TextStyle(fontSize: 16,color: blackColor),
                ),
                subtitle: const Text(
                  'Share your location from this device',
                  style: TextStyle(fontSize: 14,color: blackColorLight),
                ),
                onChanged: (value) {
                  setState(() {
                    beacon_mobile = value;
                    BeaconLocation getlocationselectedvalue=BeaconLocation(id: 1,locationselectedvalue: beacon_mobile);
                    operationStore.insert(getlocationselectedvalue);
                  });
                }),
            if (beacon_mobile == true) ...[BeaconDevicepage()],
          ],
        )),
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
                children:const [
                   SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                   SizedBox(
                    width: 30,
                  ),
                   Text('Please wait...')
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
