import 'dart:async';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:location/location.dart';

late LocationData _currentPosition;
String _address = "";
late GoogleMapController mapController;
late Marker marker;
Location location = Location();
late CameraPosition _cameraPosition =
    CameraPosition(target: LatLng(0, 0), zoom: 10.0);

LatLng initialcameraposition = LatLng(30.7333, 76.7794);

Future<String> getLoc() async {
  print('function called@! ');
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return "null";
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return "null";
    }
  }
  String details = "";

  _currentPosition = await location.getLocation();

  DateTime now = DateTime.now();

  details += "";
  details += DateFormat('EEE d MMM kk:mm:ss ').format(now);

  initialcameraposition =
      LatLng(_currentPosition.latitude!, _currentPosition.longitude!);

  details += "{}";
  details += _currentPosition.latitude.toString() +
      " , " +
      _currentPosition.longitude.toString();
  details += "{}";
  details += _address;

  return details;
}
