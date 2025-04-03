import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/marker_model.dart';

class MarkerWidget extends StatelessWidget {
  final MarkerModel model;
  final double width;
  final double height;

  const MarkerWidget({
    super.key,
    required this.model,
    this.width = 60,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(model.imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: model.borderColor, width: 2),
      ),
    );
  }
}