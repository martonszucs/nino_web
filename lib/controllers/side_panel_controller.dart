import 'package:flutter/material.dart';
import '/models/side_panel_model.dart';
import '/models/marker_model.dart';

class SidePanelController with ChangeNotifier {
  SidePanelModel? model;

  void showSingleMarker(MarkerModel marker) {
    model = SingleMarkerSidePanelModel(marker);
    notifyListeners();
  }

  // void showMultipleMarkers(List<MarkerModel> markers) {
  //   model = MultipleMarkerSidePanelModel(markers);
  //   notifyListeners();
  // }

  void closePanel() {
    model = null;
    notifyListeners();
  }

  bool get isOpen => model != null;
}
