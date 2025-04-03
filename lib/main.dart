import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/map_view.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? "";
  setGoogleMapsApiKey(apiKey);

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? "";
  final supabaseKey = dotenv.env['SUPABASE_API_KEY'] ?? "";
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(MyApp());
}

@JS('window.setGoogleMapsApiKey')
external void setGoogleMapsApiKey(String apiKey);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: const MapView(),
    );
  }
}
