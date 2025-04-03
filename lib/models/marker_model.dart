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

  factory MarkerModel.fromSupabase(Map<String, dynamic> data) {
    return MarkerModel(
      id: data['id'].toString(),
      position: LatLng(data['coordinates']['latitude'], data['coordinates']['longitude']),
      borderColor: Colors.blue,
      // imageUrl: data['image_url'],
    );
  }
}
