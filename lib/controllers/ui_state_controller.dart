import 'package:flutter/material.dart';
import '/models/marker_model.dart';

class UIStateController with ChangeNotifier {
  bool _isInteractingWithUI = false;
  bool _isMapTap = false;
  bool _showSidePanel = false;
  bool _showMultiMarkerPanel = false;
  MarkerModel? _selectedMarker;
  
  bool get isInteractingWithUI => _isInteractingWithUI;
  bool get showSidePanel => _showSidePanel;
  bool get showMultiMarkerPanel => _showMultiMarkerPanel;
  MarkerModel? get selectedMarker => _selectedMarker;

  void startUIInteraction() {
    _isInteractingWithUI = true;
    Future.delayed(Duration(milliseconds: 50), () {
      _isInteractingWithUI = false;
      notifyListeners();
    });
  }

  void handleMarkerSelection(MarkerModel marker) {
    startUIInteraction();
    _selectedMarker = marker;
    _showSidePanel = true;
    _showMultiMarkerPanel = false;
    notifyListeners();
  }

  void toggleMultiMarkerPanel() {
    startUIInteraction();
    if (_showSidePanel || _showMultiMarkerPanel) {
      _selectedMarker = null;
      _showSidePanel = false;
      _showMultiMarkerPanel = false;
    } else {
      _showMultiMarkerPanel = true;
    }
    notifyListeners();
  }

  void handleMapTap() {
    if (_isMapTap || _isInteractingWithUI) return;
    _isMapTap = true;
    Future.delayed(Duration(milliseconds: 50), () {
      if (!_isInteractingWithUI) {
        closePanels();
      }
      _isMapTap = false;
    });
  }

  void closePanels() {
    startUIInteraction();
    _selectedMarker = null;
    _showSidePanel = false;
    _showMultiMarkerPanel = false;
    notifyListeners();
  }
}
