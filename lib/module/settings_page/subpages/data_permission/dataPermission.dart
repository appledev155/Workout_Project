import 'package:anytimeworkout/isar/data_permission/dataPermissionOptions.dart';
import 'package:anytimeworkout/isar/data_permission/operation.dart' as data_store;
import 'package:anytimeworkout/module/settings_page/pages/settingPage.dart';
import 'package:flutter/material.dart';


enum PermissionValue { Allow, Decline }

class DataPermission extends StatefulWidget {
  const DataPermission({super.key});

  @override
  State<DataPermission> createState() => _DataPermissionState();
}

class _DataPermissionState extends State<DataPermission> {
  PermissionValue? permissionValue = PermissionValue.Allow;
  String store = '';

  data_store.DataOperation datastore = data_store.DataOperation();
  getdatavalue() async {
    List<DataPermissionOptions> getvalue = await datastore.getdatavalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        permissionValue =
            (getvalue.first.dataselectedvalue == "PermissionValue.Allow")
                ? PermissionValue.Allow
                : PermissionValue.Decline;
        // setState(() {
        //   if (permissionValue == PermissionValue.Allow) {
        //     store = 'Access allowed';
        //   } else {
        //     store = 'Access declined';
        //   }
        // });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatavalue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Data Permission',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    '''Strava collects and uses health data from paired devices,like a heart rate monitor,to give you intresting and useful performance analysis.We collect this data only from sensors or devices you've connected to Strava.We do not share it without yor consent.''',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1))),
                      child: const Text(
                        'Learn more',
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: ((context, setState) {
                          return Dialog(
                            child: SizedBox(
                              height: 230,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(35, 10, 0, 0),
                                    child:
                                        Text('Access to Health-Related Data'),
                                  ),
                                  ListTile(
                                    title: const Text('Allow'),
                                    leading: Radio<PermissionValue>(
                                      activeColor: Colors.orange.shade900,
                                      value: PermissionValue.Allow,
                                      groupValue: permissionValue,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            permissionValue = value;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('Decline'),
                                    leading: Radio<PermissionValue>(
                                      activeColor: Colors.orange.shade900,
                                      value: PermissionValue.Decline,
                                      groupValue: permissionValue,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            permissionValue = value;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(35, 0, 10, 0),
                                    child: Text(
                                      '''If you decline,your Strava activities will no longer include heart rate or other health-related data.''',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.orange.shade800,
                                                fontWeight: FontWeight.normal),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            if (permissionValue ==
                                                PermissionValue.Allow) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  actions: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 10, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Text(
                                                            'Access Confirmed',
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '''If you've already connected your device(s),all future activities will show heart rate and other health-related data.''',
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          store =
                                                              permissionValue
                                                                  .toString();
                                                          print(store);
                                                          DataPermissionOptions
                                                              getvalue =
                                                              DataPermissionOptions(
                                                                  id: 1,
                                                                  dataselectedvalue:
                                                                      store);
                                                          datastore
                                                              .insert(getvalue);

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Colors
                                                                  .orange
                                                                  .shade800),
                                                        ))
                                                  ],
                                                ),
                                              );
                                            } else if (permissionValue ==
                                                PermissionValue.Decline) {
                                              showDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  actions: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Are you sure?',
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '''This will prevent Strava from collecting and using health-related data.Analyzing this data can help you better understand your performance.''',
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .orange
                                                                      .shade700),
                                                            )),
                                                        TextButton(
                                                            onPressed: () {
                                                              store =
                                                                  permissionValue
                                                                      .toString();
                                                              DataPermissionOptions
                                                                  getvalue =
                                                                  DataPermissionOptions(
                                                                      id: 1,
                                                                      dataselectedvalue:
                                                                          store);
                                                              datastore.insert(
                                                                  getvalue);

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _onLoading();
                                                            },
                                                            child: Text(
                                                              'DENY PERMISSION',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .orange
                                                                      .shade700),
                                                            ))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.orange.shade800,
                                                fontWeight: FontWeight.normal),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Health-Related Data',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        store = (permissionValue == PermissionValue.Allow)
                            ? 'Access Allowed'
                            : 'Access declined',
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void _onLoading() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: CircularProgressIndicator(
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); //pop dialog
    });
  }
}
