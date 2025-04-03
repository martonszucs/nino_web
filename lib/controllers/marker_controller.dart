import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/marker_model.dart';
import '../views/widgets/marker_widget.dart';
import '/core/services/supabase_service.dart';

class MarkerController with ChangeNotifier {
  BuildContext? _context;
  StreamSubscription<List<MarkerModel>>? _markerSubscription;
  final Map<String, Marker> _markers = {}; // Track markers by ID
  final Map<String, BitmapDescriptor> _cachedIcons = {};

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
    final newMarkers = <String, Marker>{};
    
    for (final model in models) {
      if (!_cachedIcons.containsKey(model.id)) {
        _cachedIcons[model.id] = await _createMarkerIcon(model);
      }
      
      newMarkers[model.id] = Marker(
        markerId: MarkerId(model.id),
        position: model.position,
        icon: _cachedIcons[model.id]!,
        onTap: () => _handleMarkerTap(model),
      );
    }
    
    _markers
      ..clear()
      ..addAll(newMarkers);
  }

  Future<BitmapDescriptor> _createMarkerIcon(MarkerModel model) async {
    final widget = MarkerWidget(
      model: model,
    );
    return await _widgetToBitmap(widget);
  }

  Future<BitmapDescriptor> _widgetToBitmap(Widget widget) async {
    if (_context == null) throw Exception('Context not set');
    
    final key = GlobalKey();
    final overlay = OverlayEntry(
      builder: (_) => Positioned(
        left: -1000, 
        child: RepaintBoundary(
          key: key, 
          child: widget,
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

  void _handleMarkerTap(MarkerModel model) {
    debugPrint('Marker tapped: ${model.id}');
  }

  Set<Marker> get markers => _markers.values.toSet();

  @override
  void dispose() {
    _markerSubscription?.cancel();
    super.dispose();
  }
}