import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/current_location.dart';

class AmbulanceBook extends StatefulWidget {
  const AmbulanceBook({Key? key}) : super(key: key);

  @override
  State<AmbulanceBook> createState() => _AmbulanceBookState();
}

class _AmbulanceBookState extends State<AmbulanceBook> {
  late CameraPosition _mylocation;
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  late GoogleMapController newGoogleMapController;

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
            zoom: 15,
          );
        }
      });
    });
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
                    height: 210,
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
                        "Hey!",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "We are there for you ! ",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Book Nearby Ambulance'),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            )
          : Center(
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
