import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/models/marker_model.dart';
import '/views/widgets/marker_widget.dart';
import '/core/services/supabase_service.dart';
import '/core/constants/constants.dart';

class MarkerController with ChangeNotifier {
  BuildContext? _context;
  MarkerModel? selectedMarker;
  StreamSubscription<List<MarkerModel>>? _markerSubscription;
  final Map<String, Marker> _markers = {}; // Track markers by ID
  final Map<String, BitmapDescriptor> _cachedIcons = {};

  bool showSidePanel = false;
  bool showMultiMarkerPanel = false;
  List<MarkerModel> allMarkers = [];

  void setContext(BuildContext context) {
    _context = context;
  }

  void initMarkerStream() {
    _markerSubscription?.cancel();
    
    _markerSubscription = SupabaseService.getMarkerStream().listen(
      (markerModels) async {
        await _processNewMarkers(markerModels);
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Marker stream error: $error');
      },
    );
  }

  Future<void> _processNewMarkers(List<MarkerModel> models) async {
    allMarkers = models; // Store all markers
    final newMarkers = <String, Marker>{};
    
    for (final model in models) {
      if (!_cachedIcons.containsKey(model.id)) {
        _cachedIcons[model.id] = await _createMarkerIcon(model);
      }
      
      newMarkers[model.id] = Marker(
        markerId: MarkerId(model.id),
        position: model.position,
        icon: _cachedIcons[model.id]!,
        onTap: () => handleMarkerTap(model),
      );
    }
    
    _markers
      ..clear()
      ..addAll(newMarkers);
  }

  Future<BitmapDescriptor> _createMarkerIcon(MarkerModel model) async {
    // First ensure the image is loaded
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

    if (_context == null) {
      debugPrint('Context not available for marker creation');
      return BitmapDescriptor.defaultMarker;
    }
    
    // Create a new overlay entry
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
              // Reduce the size for the actual marker bitmap
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
      final navigator = Navigator.of(_context!);
      if (navigator.overlay == null) {
        debugPrint('Overlay not available for marker creation');
        return BitmapDescriptor.defaultMarker;
      }

      navigator.overlay!.insert(overlay);

      // First wait for the overlay to be inserted
      await Future.delayed(Duration(milliseconds: 50));
      
      // Then wait for the widget to be laid out
      await WidgetsBinding.instance.endOfFrame;
      
      // Then wait a bit more for the image to be loaded and rendered
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

      final bytes = byteData.buffer.asUint8List();
      return BitmapDescriptor.bytes(bytes);
    } catch (e) {
      debugPrint('Error creating marker bitmap: $e');
      return BitmapDescriptor.defaultMarker;
    } finally {
      overlay.remove();
    }
  }



  void handleMarkerTap(MarkerModel model) {
    debugPrint('Marker tapped: ${model.id}');
    selectedMarker = model;
    showSidePanel = true;
    showMultiMarkerPanel = false;
    notifyListeners();
  }

  void toggleMultiMarkerPanel() {
    if (showSidePanel) {
      closeSidePanel();
    }
    showMultiMarkerPanel = !showMultiMarkerPanel;
    notifyListeners();
  }

  void closeSidePanel() {
    selectedMarker = null;
    showSidePanel = false;
    notifyListeners();
  }

  void closeMultiMarkerPanel() {
    showMultiMarkerPanel = false;
    notifyListeners();
  }

  Set<Marker> get markers => _markers.values.toSet();

  @override
  void dispose() {
    _markerSubscription?.cancel();
    super.dispose();
  }
}
