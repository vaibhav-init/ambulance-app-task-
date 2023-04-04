import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ambulance_tracker/loading%20Animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/current_location.dart';
import 'package:ambulance_tracker/dummy_data.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<LatLng> _locations = [
    const LatLng(30.75388, 76.76770),
    const LatLng(30.75847, 76.77508),
    const LatLng(30.76244, 76.76701),
    const LatLng(30.76319, 76.76441),
    const LatLng(30.75542, 76.76184),
    const LatLng(30.74862, 76.75943),
    const LatLng(30.74759, 76.75162),
    const LatLng(30.74725, 76.74287),
    const LatLng(30.76125, 76.78076),
    const LatLng(30.75276, 76.77128),
  ];
  String imageLocation = 'assets/ambulance.png';

  late CameraPosition _mylocation;
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  Uint8List? markerImage;
  late GoogleMapController newGoogleMapController;
  final List<Marker> _marker = [
    const Marker(
      markerId: MarkerId('001'),
      position: LatLng(30.75276, 76.77128),
    ),
  ];

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    getLoc().then((locationData) {
      setState(() {
        if (locationData != "null") {
          final latLngList = locationData.split('{}');
          _mylocation = CameraPosition(
            target: LatLng(
              double.parse(latLngList[1].split(',')[0]),
              double.parse(latLngList[1].split(',')[1]),
            ),
            zoom: 15,
          );
        } else {
          _mylocation = CameraPosition(
            target: initialcameraposition,
            zoom: 16,
          );
        }
      });
    });
    loadData();
  }

  loadData() async {
    for (int i = 0; i < _locations.length; i++) {
      final Uint8List markerIcon =
          await getBytesFromAssets('assets/ambulance.png', 100);
      _marker.add(
        Marker(
            icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(
              title: 'Ambulance' + i.toString(),
            ),
            markerId: MarkerId(
              i.toString(),
            ),
            position: _locations[i]),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mylocation != null
          ? Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _mylocation,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_marker),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerGoogleMap.complete(controller);
                    newGoogleMapController = controller;
                  },
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 280,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    ),
                    child: Column(children: [
                      const Text(
                        "Searching For An Ambulance Nearby !",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      getAnimation(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Cancel Searching'),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'Location Data Not Found! Please Give location access',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }
}
