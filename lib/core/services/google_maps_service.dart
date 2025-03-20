import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleMapsService {
  static final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
