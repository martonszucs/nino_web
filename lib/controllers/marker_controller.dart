import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/models/marker_model.dart';
import '/core/services/supabase_service.dart';
import '/core/services/marker_icon_service.dart';
import '/controllers/ui_state_controller.dart';

class MarkerController with ChangeNotifier {
  static const int _maxMarkersInPanel = 50;
  static const double _minZoomLevel = 10.0;

  final BuildContext context;
  final UIStateController uiStateController;
  StreamSubscription<List<MarkerModel>>? _markerSubscription;
  final Map<String, Marker> _markers = {};
  List<MarkerModel> allMarkers = [];
  List<MarkerModel> visibleMarkers = [];
  LatLngBounds? _currentBounds;
  double _currentZoom = 11.0;

  MarkerController({
    required this.context,
    required this.uiStateController,
  });

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

  void updateVisibleBounds(LatLngBounds bounds, double zoom) {
    _currentBounds = bounds;
    _currentZoom = zoom;
    _updateVisibleMarkers();
  }

  void _updateVisibleMarkers() {
    if (_currentBounds == null) {
      visibleMarkers = allMarkers;
      return;
    }
    if (_currentZoom < _minZoomLevel) {
      visibleMarkers = [];
      return;
    }
    var filtered = allMarkers.where((marker) {
      return _currentBounds!.contains(marker.position);
    }).toList();
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    visibleMarkers = filtered.take(_maxMarkersInPanel).toList();
    notifyListeners();
  }

  Future<void> _processNewMarkers(List<MarkerModel> models) async {
    allMarkers = models;
    _updateVisibleMarkers();

    final newMarkers = <String, Marker>{};

    for (final model in models) {
      final icon = await MarkerIconService.createMarkerIcon(model);

      newMarkers[model.id] = Marker(
        markerId: MarkerId(model.id),
        position: model.position,
        icon: icon,
        onTap: () => handleMarkerTap(model),
      );
    }

    _markers
      ..clear()
      ..addAll(newMarkers);
  }

  void handleMarkerTap(MarkerModel model) {
    uiStateController.handleMarkerSelection(model);
  }

  void handleMapTap() {
    uiStateController.handleMapTap();
  }

  Set<Marker> get markers => _markers.values.toSet();
  double get currentZoom => _currentZoom;

  @override
  void dispose() {
    _markerSubscription?.cancel();
    super.dispose();
  }
}
