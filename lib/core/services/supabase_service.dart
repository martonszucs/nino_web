import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/marker_model.dart';


class SupabaseService {
  static final _supabase = Supabase.instance.client;

  static Stream<List<MarkerModel>> getMarkerStream(){
    return _supabase
      .from('reports')
      .stream(primaryKey: ['id'])
      .map((List<Map<String, dynamic>> data) =>
          data.map(MarkerModel.fromSupabase).toList());
  }
}