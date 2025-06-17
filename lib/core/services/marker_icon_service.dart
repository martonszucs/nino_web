import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/models/marker_model.dart';
import '/core/constants/constants.dart';
import '/models/category.dart';

class MarkerIconService {
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<ui.Image> _loadNetworkImage(String imageUrl) async {
    final completer = Completer<ui.Image>();
    final imageProvider = NetworkImage(imageUrl);
    imageProvider.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _) => completer.complete(info.image))
    );

    try {
      return await completer.future.timeout(Duration(seconds: 5));
    } catch (e) {
      debugPrint('Error loading marker image: $e');
      rethrow;
    }
  }

  static RRect _createMainRectangle() {
    final mainRectHeight = MarkerConstants.markerHeight - MarkerConstants.triangleHeight;
    final borderOffset = MarkerConstants.markerBorderWidth / 2;
    final markerRect = Rect.fromLTWH(
      borderOffset,
      borderOffset,
      MarkerConstants.markerWidth - MarkerConstants.markerBorderWidth,
      mainRectHeight - MarkerConstants.markerBorderWidth
    );
    return RRect.fromRectAndCorners(
      markerRect,
      topLeft: Radius.circular(MarkerConstants.markerBorderRadius),
      topRight: Radius.circular(MarkerConstants.markerBorderRadius),
      bottomLeft: Radius.circular(MarkerConstants.markerBorderRadius),
      bottomRight: Radius.circular(MarkerConstants.markerBorderRadius),
    );
  }

  static Path _createTrianglePath() {
    final mainRectHeight = MarkerConstants.markerHeight - MarkerConstants.triangleHeight;
    final trianglePath = Path();
    final triangleTop = mainRectHeight - (MarkerConstants.markerBorderWidth / 2);
    final triangleLeft = (MarkerConstants.markerWidth - MarkerConstants.triangleWidth) / 2;
    
    trianglePath.moveTo(triangleLeft, triangleTop);
    trianglePath.lineTo(
      triangleLeft + (MarkerConstants.triangleWidth / 2),
      MarkerConstants.markerHeight - (MarkerConstants.markerBorderWidth / 2)
    );
    trianglePath.lineTo(triangleLeft + MarkerConstants.triangleWidth, triangleTop);
    trianglePath.close();
    
    return trianglePath;
  }

  static RRect _createImageRRect() {
    final mainRectHeight = MarkerConstants.markerHeight - MarkerConstants.triangleHeight;
    final imageRect = Rect.fromLTWH(
      MarkerConstants.markerBorderWidth,
      MarkerConstants.markerBorderWidth,
      MarkerConstants.markerWidth - (MarkerConstants.markerBorderWidth * 2),
      mainRectHeight - (MarkerConstants.markerBorderWidth * 2)
    );
    
    return RRect.fromRectAndCorners(
      imageRect,
      topLeft: Radius.circular(MarkerConstants.markerBorderRadius),
      topRight: Radius.circular(MarkerConstants.markerBorderRadius),
      bottomLeft: Radius.circular(MarkerConstants.markerBorderRadius),
      bottomRight: Radius.circular(MarkerConstants.markerBorderRadius),
    );
  }

  static Future<BitmapDescriptor> createMarkerIcon(MarkerModel model) async {
    if (_cache.containsKey(model.id)) {
      return _cache[model.id]!;
    }

    try {
      final ui.Image image = await _loadNetworkImage(model.imageUrl);
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      
      final rrect = _createMainRectangle();
      final trianglePath = _createTrianglePath();
      final imageRRect = _createImageRRect();

      canvas.drawPath(trianglePath, Paint()
        ..color = model.category.color
        ..style = PaintingStyle.fill);

      canvas.drawRRect(rrect, Paint()
        ..color = model.category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = MarkerConstants.markerBorderWidth);
      
      canvas.save();
      canvas.clipRRect(imageRRect);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        imageRRect.outerRect,
        Paint()
      );
      canvas.restore();

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
