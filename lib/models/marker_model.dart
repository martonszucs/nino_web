import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String id;
  final LatLng position;
  final Color borderColor;
  // final String imageUrl;
  // final String number;

  MarkerModel({
    required this.id,
    required this.position,
    required this.borderColor,
    // required this.imageUrl,
    // required this.number,
  });
}
