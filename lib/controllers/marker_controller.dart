import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/models/marker_model.dart';
import '/core/services/supabase_service.dart';
import '/core/services/marker_icon_service.dart';
import '/controllers/ui_state_controller.dart';

class MarkerController with ChangeNotifier {
  final BuildContext context;
  final UIStateController uiStateController;
  StreamSubscription<List<MarkerModel>>? _markerSubscription;
  final Map<String, Marker> _markers = {};
  List<MarkerModel> allMarkers = [];

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

  Future<void> _processNewMarkers(List<MarkerModel> models) async {
    allMarkers = models;
    final newMarkers = <String, Marker>{};
    
    for (final model in models) {
      final icon = await MarkerIconService.createMarkerIcon(model, context);
      
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

  @override
  void dispose() {
    _markerSubscription?.cancel();
    super.dispose();
  }
}
