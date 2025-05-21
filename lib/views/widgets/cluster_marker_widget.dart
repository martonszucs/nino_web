import 'package:flutter/material.dart';
import 'package:nino_web/models/category.dart';
import '/models/marker_model.dart';
import '/core/constants/constants.dart';

class ClusterMarkerWidget extends StatelessWidget {
  final List<MarkerModel> markers;
  final MarkerModel representativeMarker;
  final double width;
  final double height;

  const ClusterMarkerWidget({
    super.key,
    required this.markers,
    required this.representativeMarker,
    this.width = MarkerConstants.markerWidth,
    this.height = MarkerConstants.markerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(representativeMarker.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(MarkerConstants.markerBorderRadius),
            border: Border.all(
              color: representativeMarker.category.color, 
              width: MarkerConstants.markerBorderWidth
            ),
          ),
        ),
        
        Positioned(
          bottom: -8,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  markers.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
