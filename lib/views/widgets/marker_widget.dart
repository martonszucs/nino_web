import 'package:flutter/material.dart';
import 'package:nino_web/models/category.dart';

import '/models/marker_model.dart';
import '/core/constants/constants.dart';

class MarkerWidget extends StatelessWidget {
  final MarkerModel model;
  final double width;
  final double height;

  const MarkerWidget({
    super.key,
    required this.model,
    this.width = MarkerConstants.markerWidth,
    this.height = MarkerConstants.markerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(model.imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(MarkerConstants.markerBorderRadius),
        border: Border.all(color: model.category.color, width: MarkerConstants.markerBorderWidth),
      ),
    );
  }
}
