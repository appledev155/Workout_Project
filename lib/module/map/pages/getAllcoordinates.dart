import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:anytimeworkout/isar/record_route/Show_all_data/operation.dart';
import 'package:anytimeworkout/isar/record_route/Show_all_data/recordcoordinate.dart';


class GetCoordinates extends StatefulWidget {
  const GetCoordinates({super.key});

  @override
  State<GetCoordinates> createState() => _GetCoordinatesState();
}

class _GetCoordinatesState extends State<GetCoordinates> {
  final RecordCoordinateOperation _coordinateOperation =
      RecordCoordinateOperation();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Get Coordinates'),
      ),
      body: FutureBuilder<List<RecordCoordinate>>(
          future: _coordinateOperation.getdata(),
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
                          columns: const [
                            DataColumn(label: Expanded(child: Text('Id'))),
                            DataColumn(label: Expanded(child: Text('Date'))),
                            DataColumn(label: Expanded(child: Text('Duration'))),
                            DataColumn(label: Expanded(child: Text('Latitude'))),
                            DataColumn(label: Expanded(child: Text('Longitude')))
                          ],
                          rows: List.generate(results.length, (index) {
                            final result = results[index];
                            return DataRow(cells: [
                              DataCell(Text('${result.id}')),
                              DataCell(Text('${result.date}')),
                              DataCell(Text('${result.duration}')),
                              DataCell(Text('${result.latitude}')),
                              DataCell(Text('${result.longitude}'))
                            ]);
                          })),
                    );
                  });
            }
          }),
    );
  }
}
