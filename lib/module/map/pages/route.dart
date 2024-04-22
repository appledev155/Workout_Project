import 'dart:async';
import 'dart:math';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:location/location.dart';
import 'package:anytimeworkout/isar/record_route/Show_all_data/operation.dart'
    as operation_store;
import 'package:anytimeworkout/isar/record_route/Show_all_data/recordcoordinate.dart';
import 'package:anytimeworkout/isar/record_route/Show_start_record/startendcoordinate.dart';
// import 'package:anytimeworkout/module/map/pages/getAllcoordinates.dart';
import 'package:anytimeworkout/isar/record_route/Show_start_record/operation.dart'
    as startendoperation_store;
// import 'package:anytimeworkout/module/map/pages/getStart_End_Coordinates.dart';
// import 'package:anytimeworkout/module/map/pages/recordPage.dart';
// import 'package:anytimeworkout/module/map/pages/slidingpannel.dart';

class MapPage extends StatefulWidget {
  final IconData? selectedIcon;
  String? title;
  MapPage({super.key, this.selectedIcon, this.title});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  late LocationData _startLocation;
  late LocationData _endLocation;
  late List<LatLng> _polylineCoordinates = [];
  final Set<Marker> _markers = {};
  late DateTime _startTime;
  late DateTime _endTime;
  String? timediff;
  String? date;
  LocationData? _currentLocation;
  Timer? startGettingLatLogTimer;
  operation_store.RecordCoordinateOperation operationStore =
      operation_store.RecordCoordinateOperation();
  startendoperation_store.StartEndOperation startEndOperationStore =
      startendoperation_store.StartEndOperation();
  List<double> latitude = [];
  List<double> longitude = [];
  List<double> startLatlng = [];
  List<double> endLatlng = [];
  bool buttonFlag = false;
  bool _isLoading = false;
  String? distance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    var location = Location();
    try {
      _currentLocation = await location.getLocation();
      print('*********$_currentLocation**********');

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                _currentLocation!.latitude!, _currentLocation!.longitude!),
            zoom: 15.0,
          ),
        ),
      );

      setState(() {});
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Google Map",style:TextStyle(fontSize:12,color: Colors.black),)),
        toolbarHeight: 50,
        backgroundColor:greyColor,
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(cancle,color: primaryColor,))
      ),
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 15.0,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
                _getCurrentLocation();
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId('polyline'),
                  points: _polylineCoordinates,
                  color: Colors.blue,
                  width: 3,
                ),
              },
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // Positioned(
          //   bottom: 30,
          //   left: 150,
          //   child: SizedBox(
          //     height: 70,
          //     width: 80,
          //     child: FloatingActionButton(
          //       backgroundColor: Colors.orange.shade800,
          //       onPressed: () {
          //         _buttonAction();
          //       },
          //       child: buttonFlag == false
          //           ? const Text(
          //               'START',
          //               style: TextStyle(
          //                   color: Colors.white, fontWeight: FontWeight.bold),
          //             )
          //           : const Text(
          //               'STOP',
          //               style: TextStyle(
          //                   color: Colors.white, fontWeight: FontWeight.bold),
          //             ),
          //     ),
          //   ),
          // )
          // Positioned(
          //   bottom: 150,
          //   right: 10,
          //   child: Column(
          //     children: [
          //       SizedBox(
          //         height: 40,
          //         width: 40,
          //         child: OutlinedButton(
          //           style: OutlinedButton.styleFrom(
          //               backgroundColor: Colors.white,
          //               shape: const RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.zero),
          //               padding: const EdgeInsets.fromLTRB(0, 0, 1, 0)),
          //           onPressed: () {
          //             _mapController?.animateCamera(CameraUpdate.zoomIn());
          //           },
          //           child: const Icon(
          //             Icons.add,
          //             color: Colors.black,
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 40,
          //         width: 40,
          //         child: OutlinedButton(
          //           style: OutlinedButton.styleFrom(
          //               backgroundColor: Colors.white,
          //               shape: const RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.zero),
          //               padding: const EdgeInsets.fromLTRB(0, 0, 1, 0)),
          //           onPressed: () {
          //             _mapController?.animateCamera(CameraUpdate.zoomOut());
          //           },
          //           child: const Icon(
          //             Icons.remove,
          //             color: Colors.black,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 80,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            _buttonAction();
          },
          child: buttonFlag == false
              ? const Text(
                  'START',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              : const Text(
                  'STOP',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // bottomSheet: BottomSheet(
      //     enableDrag: false,
      //     onClosing: () {},
      //     builder: (BuildContext context) {
      //       return Container(
      //         decoration: BoxDecoration(
      //             border: Border.all(color: Colors.black26, width: 0.2)),
      //         height: 140,
      //         width: MediaQuery.of(context).size.width,
      //         child: Column(
      //           children: [
      //             IntrinsicHeight(
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   IconButton(
      //                       onPressed: () {},
      //                       icon: Icon(
      //                         Icons.route_outlined,
      //                         color: Colors.orange.shade800,
      //                       )),
      //                   const Padding(
      //                     padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      //                     child: VerticalDivider(
      //                       thickness: 0.3,
      //                       color: Colors.black26,
      //                     ),
      //                   ),
      //                   IconButton(
      //                       onPressed: () {
      //                         // showDialog(
      //                         //     context: context,
      //                         //     builder: (context) => SlidinUpPanelPage());
      //                       },
      //                       icon: widget.selectedIcon == null
      //                           ? Icon(
      //                               Icons.run_circle_outlined,
      //                               color: Colors.orange.shade900,
      //                             )
      //                           : Icon(
      //                               widget.selectedIcon,
      //                               color: Colors.orange.shade900,
      //                             )),
      //                   const Padding(
      //                     padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      //                     child: VerticalDivider(
      //                       thickness: 0.3,
      //                       color: Colors.black26,
      //                     ),
      //                   ),
      //                   IconButton(
      //                       onPressed: () {},
      //                       icon: const Icon(
      //                         Icons.favorite_outline_sharp,
      //                       )),
      //                   const Padding(
      //                     padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      //                     child: VerticalDivider(
      //                       thickness: 0.3,
      //                       color: Colors.black26,
      //                     ),
      //                   ),
      //                   IconButton(
      //                       onPressed: () {},
      //                       icon: const Icon(Icons.surround_sound_outlined)),
      //                   const Padding(
      //                     padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      //                     child: VerticalDivider(
      //                       thickness: 0.3,
      //                       color: Colors.black26,
      //                     ),
      //                   ),
      //                   IconButton(
      //                       onPressed: () {},
      //                       icon: const Icon(Icons.music_note_outlined))
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             SizedBox(
      //               height: 70,
      //               width: 80,
      //               child: FloatingActionButton(
      //                 backgroundColor: Colors.orange.shade900,
      //                 onPressed: () {
      //                   _buttonAction();
      //                 },
      //                 child: buttonFlag == false
      //                     ? const Text(
      //                         'START',
      //                         style: TextStyle(
      //                             color: Colors.white,
      //                             fontWeight: FontWeight.bold),
      //                       )
      //                     : const Text(
      //                         'STOP',
      //                         style: TextStyle(
      //                             color: Colors.white,
      //                             fontWeight: FontWeight.bold),
      //                       ),
      //               ),
      //             )
      //           ],
      //         ),
      //       );
      //     }),
    );
  }

  Future<LocationData> _getLocation() async {
    Location location = Location();
    return await location.getLocation();
  }

  void _buttonAction() async {
    setState(() {
      buttonFlag = !buttonFlag;
      print(buttonFlag);
    });
    if (buttonFlag == true) {
      _startLocation = await _getLocation();
      _startTime = DateTime.now();
      // print(_startTime);
      startGettingLatLogTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) async {
        LocationData currentLocation = await _getLocation();
        _updatePolyline(currentLocation.latitude!, currentLocation.longitude!);
        _addMarker(
            'start', _startLocation.latitude!, _startLocation.longitude!);
        setState(() {});
      });
      latitude.clear();
      longitude.clear();
      _polylineCoordinates.clear();
    }

    if (buttonFlag == false) {
      startGettingLatLogTimer?.cancel();
      _endLocation = await _getLocation();
      _endTime = DateTime.now();
      LocationData currentLocation = await _getLocation();
      _updatePolyline(currentLocation.latitude!, currentLocation.longitude!);
      _addMarker('end', _endLocation.latitude!, _endLocation.longitude!);
      _calculateTimeSpent();
      RecordCoordinate getdata = RecordCoordinate(
          latitude: latitude,
          longitude: longitude,
          duration: timediff,
          distance: distance,
          date: date);
      operationStore.insert(getdata);
      startLatlng = [latitude.first, longitude.first];
      endLatlng = [latitude.last, longitude.last];
      //print(endLatlng);
      StartEndCoordinate getcoordinates = StartEndCoordinate(
          date: date,
          duration: timediff,
          distance: distance,
          startLatlng: startLatlng,
          endLatlng: endLatlng);
      startEndOperationStore.insert(getcoordinates);
      setState(() {});
    }
  }


  void _updatePolyline(double latitude1, double longitude1) {

    setState(() {
      _polylineCoordinates.add(LatLng(latitude1, longitude1));
      _polylineCoordinates = _polylineCoordinates;
      print('**********$_polylineCoordinates**********');
      latitude.add(latitude1);
      latitude = latitude;
      longitude.add(longitude1);
      longitude = longitude;
      double totaldistance = 0;
      for (var i = 0; i < _polylineCoordinates.length - 1; i++) {
        totaldistance += calculateDistance(
            _polylineCoordinates[i].latitude,
            _polylineCoordinates[i].longitude,
            _polylineCoordinates[i + 1].latitude,
            _polylineCoordinates[i + 1].longitude);
      }
      //  print(totaldistance);
      setState(() {
        distance = '${totaldistance.toStringAsFixed(3)} km';
        print('$distance');
      });
    });
  }

  // void _addMarker(double latitude, double longitude) {
  //   setState(() {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId(_markers.length.toString()),
  //         position: LatLng(latitude, longitude),
  //         infoWindow: InfoWindow(title: 'Marker ${_markers.length}'),
  //         icon: BitmapDescriptor.defaultMarker,
  //       ),
  //     );
  //   });
  // }
  // void _updatePolyline() {
  //   setState(() {
  //     _polylineCoordinates = [
  //       LatLng(_startLocation.latitude!, _startLocation.longitude!),
  //       LatLng(_endLocation.latitude!, _endLocation.longitude!),
  //     ];
  //     print(_polylineCoordinates);
  //   });
  // }

  void _addMarker(String markerId, double latitude, double longitude) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: markerId),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  void _calculateTimeSpent() {
    if (_startTime != null && _endTime != null) {
      Duration timeDifference = _endTime.difference(_startTime);
      timediff =
          '${timeDifference.inMinutes}min ${timeDifference.inSeconds % 60}sec';
      final time = DateFormat('hh:mm a').format(DateTime.now());
      String formattedDate =
          '${DateFormat.yMMMMd().format(DateTime.now())} at $time';
      date = formattedDate;
      print(
          'You spent ${timeDifference.inMinutes} minutes and ${timeDifference.inSeconds % 60} seconds on $formattedDate');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Time Spent'),
            content: Text(
                'You spent ${timeDifference.inMinutes} minutes and ${timeDifference.inSeconds % 60} seconds and distance $distance on $formattedDate'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  //     MaterialPageRoute(builder: (context) => TimerScreen()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             const CountdownTimerScreen()));
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.orange.shade900),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}

// void _addMarker(double latitude, double longitude) {
//   setState(() {
//     _markers.add(
//       Marker(
//         markerId: MarkerId(_markers.length.toString()),
//         position: LatLng(latitude, longitude),
//         infoWindow: InfoWindow(title: 'Marker ${_markers.length}'),
//         icon: BitmapDescriptor.defaultMarker,
//       ),
//     );
//   });
// }

