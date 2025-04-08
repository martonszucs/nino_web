import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/marker_model.dart';


class SupabaseService {
  static final _supabase = Supabase.instance.client;

  static Stream<List<MarkerModel>> getMarkerStream() {
    return _supabase
        .from('reports')
        .stream(primaryKey: ['id'])
        .asyncMap((data) async {
          return await Future.wait(
            data.map((item) => MarkerModel.fromSupabase(item))
          );
        });
  }

  static Future<String> getImageUrlFromNewsBucket(String newsId) async{
    final files = await _supabase.storage.from('news').list(path: newsId);
    if (files.isEmpty) throw Exception('No images found in folder $newsId');
    return _getImageUrl('$newsId/${files.first.name}');
  }

  static String _getImageUrl(String path) {
    String imageUrl = _supabase.storage.from('news').getPublicUrl(path);
    return imageUrl;
  }
}