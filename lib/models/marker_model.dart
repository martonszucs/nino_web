import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/core/services/supabase_service.dart';

class MarkerModel {
  final String id;
  final LatLng position;
  final Color borderColor;
  final String imageUrl;
  // final String number;

  MarkerModel({
    required this.id,
    required this.position,
    required this.borderColor,
    required this.imageUrl,
    // required this.number,
  });

  static Future<MarkerModel> fromSupabase(Map<String, dynamic> data) async {
    final markerId = data['id'].toString();
    final latitude = data['coordinates']['latitude'];
    final longitude = data['coordinates']['longitude'];
    
    return MarkerModel(
      id: markerId,
      position: LatLng(latitude, longitude),
      borderColor: Colors.blue,
      imageUrl: await SupabaseService.getImageUrlFromNewsBucket(markerId),
    );
  }
}
