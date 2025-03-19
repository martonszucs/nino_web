import 'package:geolocator/geolocator.dart';

import '/core/constants/constants.dart';


class LocationService {

  Future<bool> _isPermissionGranted() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  Future<Position> getCurrentLocation() async {
    bool isPermissionGranted = await _isPermissionGranted();
    if (!isPermissionGranted){
      Map<String, double> positionMap = {
        'latitude': LocationConstants.defaultLatitude,
        'longitude': LocationConstants.defaultLongitude
      };
      Position position = Position.fromMap(positionMap);
      return position;
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}