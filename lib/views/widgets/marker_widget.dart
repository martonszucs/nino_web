import 'package:flutter/material.dart';
import '../../models/marker_model.dart';

class MarkerWidget extends StatelessWidget {
  final String assetImagePath;
  final double width;
  final double height;
  final MarkerModel model;

  const MarkerWidget({
    super.key,
    required this.model,
    required this.assetImagePath,
    this.width = 60,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/protest.jpg"),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              debugPrint('Image load error: $exception'); 
              const Placeholder(); 
            }, 
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: model.borderColor, width: 2),
        )
      ),
    );
  }
}
