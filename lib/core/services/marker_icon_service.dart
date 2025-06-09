import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/models/marker_model.dart';
import '/views/widgets/marker_widget.dart';
import '/core/constants/constants.dart';

class MarkerIconService {
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> createMarkerIcon(
    MarkerModel model,
    BuildContext context,
  ) async {
    if (_cache.containsKey(model.id)) {
      return _cache[model.id]!;
    }

    try {
      final icon = await _generateMarkerIcon(model, context);
      _cache[model.id] = icon;
      return icon;
    } catch (e) {
      debugPrint('Error creating marker icon: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<BitmapDescriptor> _generateMarkerIcon(
    MarkerModel model,
    BuildContext context,
  ) async {
    final completer = Completer<ImageInfo>();
    final image = NetworkImage(model.imageUrl);
    image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _) => completer.complete(info))
    );

    try {
      await completer.future.timeout(Duration(seconds: 5));
    } catch (e) {
      debugPrint('Error loading marker image: $e');
      return BitmapDescriptor.defaultMarker;
    }

    final key = GlobalKey();
    final overlay = OverlayEntry(
      builder: (_) => Positioned(
        left: -1000,
        top: -1000,
        child: Material(
          type: MaterialType.transparency,
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: MarkerConstants.markerWidth,
              height: MarkerConstants.markerHeight,
              child: MarkerWidget(
                model: model,
                width: MarkerConstants.markerWidth,
                height: MarkerConstants.markerHeight,
              ),
            ),
          ),
        ),
      ),
    );

    try {
      Navigator.of(context).overlay?.insert(overlay);
      await Future.delayed(Duration(milliseconds: 50));
      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(Duration(milliseconds: 200));

      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Failed to find RepaintBoundary');
      }

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        throw Exception('Failed to get byte data from image');
      }

      return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
    } finally {
      overlay.remove();
    }
  }

  static void clearCache() {
    _cache.clear();
  }
}
