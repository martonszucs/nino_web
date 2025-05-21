import 'package:flutter/material.dart';
import '/models/marker_model.dart';
import '/views/widgets/side_panel/single_marker_side_panel_widget.dart';

abstract class SidePanelModel {
  Widget build(BuildContext context, {required bool isDesktop});
}

class SingleMarkerSidePanelModel extends SidePanelModel {
  final MarkerModel marker;
  SingleMarkerSidePanelModel(this.marker);

  @override
  Widget build(BuildContext context, {required bool isDesktop}) {
    return SingleMarkerSidePanel(isDesktop: isDesktop, selectedMarker: marker);
  }
}

// class MultipleMarkerSidePanelModel extends SidePanelModel {
//   final List<MarkerModel> markers;
//   MultipleMarkerSidePanelModel(this.markers);

//   @override
//   Widget build(BuildContext context, {required bool isDesktop}) {
//     return MultipleMarkerSidePanel(markers: markers);
//   }
// }
