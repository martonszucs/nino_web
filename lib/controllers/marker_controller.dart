import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/marker_model.dart';
import '../views/widgets/marker_widget.dart';

class MarkerController with ChangeNotifier {
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<BitmapDescriptor> _widgetToBitmap(Widget widget) async {
    if (_context == null) throw Exception('Context not set');
    
    final key = GlobalKey();
    final overlay = OverlayEntry(
      builder: (_) => Positioned(
        left: -1000, 
        child: RepaintBoundary(
          key: key, 
          child: widget
        ),
      ),
    );

    Navigator.of(_context!).overlay?.insert(overlay);
    await Future.delayed(const Duration(milliseconds: 50));

    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage();
    final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData?.buffer.asUint8List();

    overlay.remove();
    return BitmapDescriptor.bytes(uint8List!);
  }

  Future<Marker> createMarker(String id, LatLng position, Color borderColor, String assetImagePath) async {
    MarkerModel model = MarkerModel(id: id, position: position, borderColor: borderColor);
    MarkerWidget widget = MarkerWidget(assetImagePath: assetImagePath, model: model);
    final icon = await _widgetToBitmap(widget);
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: icon,
    );
  }
}