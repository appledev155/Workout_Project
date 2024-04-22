import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class MapPage1 extends StatefulWidget {
  const MapPage1({super.key});

  @override
  State<MapPage1> createState() => _MapPage1State();
}

class _MapPage1State extends State<MapPage1> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  bool _isLoading = false;
  int _seconds = 0;
  Timer? _timer;
  bool _timerStarted = false;
  late List<LatLng> _polylineCoordinates = [];
  final Set<Marker> _markers = {};
  late LocationData _startLocation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        print(_seconds);
      });
    });
    print(_seconds);
    setState(() {
      _timerStarted = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: LatLng(0, 0), zoom: 15),
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
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 100,
        width: 70,
        child: FloatingActionButton(
            backgroundColor: Colors.orange.shade900,
            onPressed: () {
              _startMethod();
              print('*******startmethod*******');
              getmethod();
              print('********getmethod******');
              _timerStarted = true;
              _startTimer();
            },
            child: const Text(
              'START',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<LocationData> _getLocation() async {
    Location location = Location();
    return await location.getLocation();
  }

  void _updatePolyline(double latitude1, double longitude1) {
    setState(() {
      _polylineCoordinates.add(LatLng(latitude1, longitude1));
      _polylineCoordinates = _polylineCoordinates;
      print('**********$_polylineCoordinates**********');
    });
  }

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

  void getmethod() async {
    _startLocation = await _getLocation();
    print(_startLocation);
    _addMarker('start', _startLocation.latitude!, _startLocation.longitude!);
    LocationData currentLocation = await _getLocation();
    _updatePolyline(currentLocation.latitude!, currentLocation.longitude!);
  }

  void _startMethod() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          String formattedTime = DateFormat('HH:mm:ss')
              .format(DateTime(0).add(Duration(seconds: _seconds)));
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('TIME'),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(formattedTime),
                  ],
                ),
              );
            },
          );
        });
  }
}
