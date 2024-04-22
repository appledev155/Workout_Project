import 'dart:math';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anytimeworkout/isar/record_route/Show_start_record/operation.dart';
import 'package:anytimeworkout/isar/record_route/Show_start_record/startendcoordinate.dart';

class StartEndCoordinatePage extends StatefulWidget {
  const StartEndCoordinatePage({super.key});

  @override
  State<StartEndCoordinatePage> createState() => _StartEndCoordinatePageState();
}

class _StartEndCoordinatePageState extends State<StartEndCoordinatePage> {
  final StartEndOperation _startEndOperation = StartEndOperation();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Get Coordinates',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<StartEndCoordinate>>(
          future: _startEndOperation.getdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error:${snapshot.error}');
            } else {
              final results = snapshot.data ?? [];
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: DataTable(
                        border: TableBorder.all(color: Colors.grey.shade200),
                        columns: const [
                          DataColumn(
                              label: Expanded(
                                  child: Text(
                            'Id',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))),
                          DataColumn(
                              label: Expanded(
                                  child: Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))),
                          DataColumn(
                              label: Expanded(
                                  child: Text(
                            'Duration',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))),
                          DataColumn(
                              label: Expanded(
                                  child: Text(
                            'Distance',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))),
                          DataColumn(
                              label: Expanded(
                                  child: Text(
                            'StartLatLng',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ))),
                          DataColumn(
                              label: Expanded(
                                  child: Text(
                            'EndLatLng',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )))
                        ],
                        rows: List.generate(results.length, (index) {
                          final result = results[index];
                          var s1 = result.startLatlng;
                          var s2 = result.endLatlng;
                          double lat1 = s1![0];
                          // print(lat1);
                          double lng1 = s1[1];
                          //print(lng1);
                          double lat2 = s2![0];
                          double lng2 = s2[1];
                          double calculateDistance(lat1, lng1, lat2, lng2) {
                            var p = 0.017453292519943295;
                            var c = cos;
                            var a = 0.5 -
                                c((lat2 - lat1) * p) / 2 +
                                c(lat1 * p) *
                                    c(lat2 * p) *
                                    (1 - c((lng2 - lng1) * p)) /
                                    2;
                            return 12742 * asin(sqrt(a));
                          }

                          double totaldistance =
                              calculateDistance(lat1, lng1, lat2, lng2);
                          print(totaldistance);
                          var f = NumberFormat("##0.0###", "en_US");
                          // print(f.format(totaldistance));
                          var distance = f.format(totaldistance);
                          String storeStartLatLng =
                              result.startLatlng.toString();
                          storeStartLatLng = storeStartLatLng.substring(
                              1, storeStartLatLng.length - 1);
                          //print(store);
                          String storeEndLatLng = result.endLatlng.toString();
                          storeEndLatLng = storeEndLatLng.substring(
                              1, storeEndLatLng.length - 1);
                          // for(int i=0;i<store!.length;i++){
                          //   var display=store[i];
                          //   display1=display;
                          //  print('*******$display1***');
                          //  print(display);
                          // }
                          return DataRow(cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(Text('${result.date}')),
                            DataCell(Text('${result.duration}')),
                            DataCell(Text(distance)),
                            DataCell(Text(storeStartLatLng)),
                            DataCell(Text(storeEndLatLng))
                          ]);
                        }),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
