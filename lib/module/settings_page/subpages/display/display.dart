import 'package:anytimeworkout/isar/display/display.dart';
import 'package:anytimeworkout/isar/display/operation.dart' as display_store;
import 'package:anytimeworkout/module/settings_page/pages/settingPage.dart';
import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/styles.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  display_store.DisplayOperation displaystore =
      display_store.DisplayOperation();

  String _measurevalue = '';
  String _tempvalue = '';
  String _defaultvalue = '';
  void checkmeasure(value) {
    _measurevalue = value;
    Navigator.of(context).pop();
  }

  void checktemp(value) {
    _tempvalue = value;
    Navigator.of(context).pop();
  }

  void checkdefault(value) {
    _defaultvalue = value;
    Navigator.of(context).pop();
  }

  getvalue() async {
    List<Display> getvalue = await displaystore.getselectvalue();
    List<Display> tempvalue = await displaystore.gettemp();
    List<Display> defaultvalue = await displaystore.getdefault();
    print(getvalue);
    if (getvalue.isNotEmpty) {
      setState(() {
        _measurevalue = (getvalue.first.selectedmeasurevalue == "Imperial")
            ? "Imperial"
            : "Metric";
        print(_measurevalue);
      });
    }
    if (tempvalue.isNotEmpty) {
      setState(() {
        _tempvalue = (tempvalue.first.selectedtempvalue == "Celsius")
            ? "Celsius"
            : "Fahrenheit";
      });
    }
    if (defaultvalue.isNotEmpty) {
      setState(() {
        _defaultvalue =
            (defaultvalue.first.selecteddefaultvalue == "Activity Feed")
                ? "Activity Feed"
                : "Record Activity";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Display',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Units of Measure'),
                          actions: [
                            RadioListTile(
                                activeColor: primaryColorDark,
                                title: const Text('Imperial'),
                                value: 'Imperial',
                                groupValue: _measurevalue,
                                onChanged: (value) => setState(() {
                                      checkmeasure(value);
                                      Display getvalue = Display(
                                          id: 1,
                                          selectedmeasurevalue: _measurevalue,
                                          selectedtempvalue: _tempvalue,
                                          selecteddefaultvalue: _defaultvalue);
                                      displaystore.insert(getvalue);
                                    })),
                            RadioListTile(
                                activeColor: primaryColorDark,
                                title: const Text('Metric'),
                                value: 'Metric',
                                groupValue: _measurevalue,
                                onChanged: (value) => setState(() {
                                      checkmeasure(value);
                                      Display getvalue = Display(
                                          id: 1,
                                          selectedmeasurevalue: _measurevalue,
                                          selectedtempvalue: _tempvalue,
                                          selecteddefaultvalue: _defaultvalue);
                                      displaystore.insert(getvalue);
                                    })),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: primaryColor),
                                ))
                          ],
                        ));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Units of Measure',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                    ),
                    Text(
                      _measurevalue,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: pageTextSize,
                          color: blackColorLight),
                    )
                  ],
                ),
              )),
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Temperature'),
                        actions: [
                          RadioListTile(
                              activeColor: primaryColorDark,
                              title: const Text('Celsius'),
                              value: 'Celsius',
                              groupValue: _tempvalue,
                              onChanged: (value) => setState(() {
                                    checktemp(value);
                                    Display getvalue = Display(
                                        id: 1,
                                        selectedtempvalue: _tempvalue,
                                        selectedmeasurevalue: _measurevalue,
                                        selecteddefaultvalue: _defaultvalue);
                                    displaystore.insert(getvalue);
                                  })),
                          RadioListTile(
                              activeColor: primaryColorDark,
                              title: const Text('Fahrenheit'),
                              value: 'Fahrenheit',
                              groupValue: _tempvalue,
                              onChanged: (value) => setState(() {
                                    checktemp(value);
                                    Display getvalue = Display(
                                        id: 1,
                                        selectedtempvalue: _tempvalue,
                                        selectedmeasurevalue: _measurevalue,
                                        selecteddefaultvalue: _defaultvalue);
                                    displaystore.insert(getvalue);
                                  })),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: primaryColor),
                              ))
                        ],
                      ));
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: pageIconSize,
                        color: blackColorDark),
                  ),
                  Text(
                    _tempvalue,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: pageTextSize,
                        color: blackColorLight),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Default Tab'),
                          actions: [
                            RadioListTile(
                                activeColor: primaryColorDark,
                                title: const Text('Activity Feed'),
                                value: 'Activity Feed',
                                groupValue: _defaultvalue,
                                onChanged: (value) => setState(() {
                                      checkdefault(value);
                                      Display getvalue = Display(
                                          id: 1,
                                          selectedmeasurevalue: _measurevalue,
                                          selectedtempvalue: _tempvalue,
                                          selecteddefaultvalue: _defaultvalue);
                                      displaystore.insert(getvalue);
                                    })),
                            RadioListTile(
                                activeColor: primaryColorDark,
                                title: const Text('Record Activity'),
                                value: 'Record Activity',
                                groupValue: _defaultvalue,
                                onChanged: (value) => setState(() {
                                      checkdefault(value);
                                      Display getvalue = Display(
                                          id: 1,
                                          selectedmeasurevalue: _measurevalue,
                                          selectedtempvalue: _tempvalue,
                                          selecteddefaultvalue: _defaultvalue);
                                      displaystore.insert(getvalue);
                                    })),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: primaryColor),
                                ))
                          ],
                        ));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Default Tab',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                    ),
                    Text(
                      _defaultvalue,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: pageTextSize,
                          color: blackColorLight),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
