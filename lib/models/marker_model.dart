import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/models/category.dart';
import '/core/services/supabase_service.dart';

class MarkerModel {
  final String id;
  final String authorId;
  final LatLng position;
  final String imageUrl;
  final MarkerCategory category;
  final String timestamp;

  MarkerModel({
    required this.id,
    required this.authorId,
    required this.position,
    required this.imageUrl,
    required this.category,
    required this.timestamp
  });

  static Future<MarkerModel> fromSupabase(Map<String, dynamic> data) async {
    final String markerId = data['id'].toString();
    final String authorId = data['originator'];
    final double latitude = data['coordinates']['latitude'];
    final double longitude = data['coordinates']['longitude'];
    final MarkerCategory category = MarkerCategoryColor.fromString(data['category']);
    final String timestamp = data['timestamp'].toString();

    
    return MarkerModel(
      id: markerId,
      authorId: authorId,
      position: LatLng(latitude, longitude),
      category: category,
      timestamp: timestamp,
      imageUrl: await SupabaseService.getImageUrlFromNewsBucket(markerId),
    );
  }
}
