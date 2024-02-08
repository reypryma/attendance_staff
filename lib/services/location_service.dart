import 'package:attendance_staff/helper/utills.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

abstract class ILocationService{
  Future<Map<String, double?>?> initializeAndGetLocation(
      BuildContext context);

}

class LocationService implements ILocationService {
  Location location = Location();
  late LocationData _locationData;

  @override
  Future<Map<String, double?>?> initializeAndGetLocation(BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // First check whether location is enabled or not in the device
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Utils.showSnackBar("Please Enable Location Service", context);
        return null;
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Utils.showSnackBar("Please Allow Location Access", context);
        return null;
      }
    }

    // After permissison is granted then return the cordinates
    _locationData = await location.getLocation();
    return {
      'latitude': _locationData.latitude,
      'longitude': _locationData.longitude,
    };
  }
}