import 'package:flutter/material.dart';

import 'package:nino_web/models/marker_model.dart';
import 'package:nino_web/views/widgets/side_panel/header_row_widget.dart';
import 'package:nino_web/views/widgets/side_panel/link_row_widget.dart';

class SidePanel extends StatelessWidget {
  final bool isDesktop;
  final MarkerModel selectedMarker;

  const SidePanel({
    super.key,
    required this.isDesktop,
    required this.selectedMarker,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: isDesktop ? screenWidth * 0.33 : screenWidth - 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final shouldWrapLinks = constraints.maxWidth < 400;
              if (!isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/nino.png',
                      height: 32,
                      width: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Nino!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontFamily: 'ChakraPetch',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: LinkRow(alignment: Alignment.centerLeft),
                    ),
                  ],
                );
              } else if (shouldWrapLinks) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderRow(),
                    SizedBox(height: 8),
                    LinkRow(alignment: Alignment.centerLeft),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: HeaderRow()),
                    LinkRow(alignment: Alignment.centerRight),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.85,
                ),
                child: Image.network(
                  selectedMarker.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
