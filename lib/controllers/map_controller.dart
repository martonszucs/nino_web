import 'package:flutter/material.dart';

class MapController with ChangeNotifier {
  double latitude = 37.7749; // Default Lat
  double longitude = -122.4194; // Default Lng

  void updateLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }
}