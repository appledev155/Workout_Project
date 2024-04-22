

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultMapPage extends StatefulWidget {
  const DefaultMapPage({super.key});

  @override
  State<DefaultMapPage> createState() => _DefaultMapPageState();
}

class _DefaultMapPageState extends State<DefaultMapPage> {
  bool checkboxValue = false;
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
        title: const Text(
          'Default Maps',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20,0,0,0),
                child: Text('Use 3D Maps for Trail Sports'),
              ),
              Checkbox(value: checkboxValue, onChanged: null),
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20,0,0,0),
            child: Text('''This will apply to future uploads of the following activities: Hike,Trail Run, Mountain Bike Ride,Gravel Ride,Alpine Ski,Backcountry Ski,Snowboard,Snowshoe.''',
            style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20,0,0,0),
            child: Text('Previous activity uploads will not be changed.',style: TextStyle(fontSize: 12),),
          )
        ],
      )),
    );
  }
}
