import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  final List<List<LatLng>> polylineCoordinatesList; // Store multiple lists of polyline coordinates
  final List<double> distances; // Store distances for each activity
  final List<String> times; // Store times for each activity

  HomePage({required this.polylineCoordinatesList, required this.distances, required this.times});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overall Activities'),
      ),
      body: ListView.builder(
        itemCount: polylineCoordinatesList.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Activity ${index + 1}:'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Distance: ${distances[index]}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Time: ${times[index]}'),
              ),
              SizedBox(
                height: 200, // Adjust the height of the Google Map widget
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: polylineCoordinatesList[index].first,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('start$index'),
                      position: polylineCoordinatesList[index].first,
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    ),
                    Marker(
                      markerId: MarkerId('end$index'),
                      position: polylineCoordinatesList[index].last,
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: PolylineId('activity$index'),
                      points: polylineCoordinatesList[index],
                      color: Colors.blue,
                      width: 5,
                    ),
                  },
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
