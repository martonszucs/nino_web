import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/map_view.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'YOUR_DEFAULT_API_KEY';

  setGoogleMapsApiKey(apiKey);

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
