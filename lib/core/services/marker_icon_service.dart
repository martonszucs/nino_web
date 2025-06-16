import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/models/marker_model.dart';
import '/core/constants/constants.dart';
import '/models/category.dart';

class MarkerIconService {
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> createMarkerIcon(
    MarkerModel model,
  ) async {
    if (_cache.containsKey(model.id)) {
      return _cache[model.id]!;
    }

    try {
      // Load the network image
      final completer = Completer<ui.Image>();
      final imageProvider = NetworkImage(model.imageUrl);
      imageProvider.resolve(ImageConfiguration.empty).addListener(
        ImageStreamListener((info, _) => completer.complete(info.image))
      );

      final ui.Image image;
      try {
        image = await completer.future.timeout(Duration(seconds: 5));
      } catch (e) {
        debugPrint('Error loading marker image: $e');
        return BitmapDescriptor.defaultMarker;
      }

      // PictureRecorder to draw marker
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      
      final mainRectHeight = MarkerConstants.markerHeight - MarkerConstants.triangleHeight;
      final markerRect = Rect.fromLTWH(0, 0, MarkerConstants.markerWidth, mainRectHeight);
      final radius = Radius.circular(MarkerConstants.markerBorderRadius);
      final rrect = RRect.fromRectAndCorners(
        markerRect,
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );
      
      // Make triangle path
      final trianglePath = Path();
      final triangleTop = mainRectHeight; 
      final triangleLeft = (markerRect.width - MarkerConstants.triangleWidth) / 2;
      
      trianglePath.moveTo(triangleLeft, triangleTop); 
      trianglePath.lineTo(triangleLeft + (MarkerConstants.triangleWidth / 2), MarkerConstants.markerHeight); 
      trianglePath.lineTo(triangleLeft + MarkerConstants.triangleWidth, triangleTop);
      trianglePath.close(); 
      
      // Draw and fill triangle
      final trianglePaint = Paint()
        ..color = model.category.color
        ..style = PaintingStyle.fill;
      canvas.drawPath(trianglePath, trianglePaint);

      // Draw background with border
      final backgroundPaint = Paint()
        ..color = model.category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = MarkerConstants.markerBorderWidth;
      canvas.drawRRect(rrect, backgroundPaint);
      
      // Calculate image rect with padding for border
      final padding = MarkerConstants.markerBorderWidth / 2; 
      final imageRect = Rect.fromLTWH(
        padding,
        padding,
        MarkerConstants.markerWidth - (padding * 2),
        mainRectHeight - (padding * 2)
      );
      
      // Create image RRect with same radius as border
      final imageRRect = RRect.fromRectAndCorners(
        imageRect,
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );
      
      // Save canvas state before clipping
      canvas.save();
      
      // Clip and draw image
      canvas.clipRRect(imageRRect);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        imageRect,
        Paint()
      );
      
      // Restore canvas state after clipping
      canvas.restore();

      // Convert to image
      final picture = pictureRecorder.endRecording();
      final img = await picture.toImage(
        MarkerConstants.markerWidth.toInt(),
        MarkerConstants.markerHeight.toInt(),
      );
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        throw Exception('Failed to get byte data from image');
      }

      final icon = BitmapDescriptor.bytes(byteData.buffer.asUint8List());
      _cache[model.id] = icon;
      return icon;
    } catch (e) {
      debugPrint('Error creating marker icon: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  static void clearCache() {
    _cache.clear();
  }
}
