import 'package:flutter/material.dart';
import '/models/side_panel_model.dart';

class SidePanel extends StatelessWidget {
  final SidePanelModel model;
  final bool isDesktop;
  const SidePanel({
    required this.model,
    required this.isDesktop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return model.build(context, isDesktop: isDesktop);
  }
}
