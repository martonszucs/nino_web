import 'package:flutter/material.dart';
import 'package:nino_web/models/category.dart';
import '/models/marker_model.dart';
import 'header_row_widget.dart';
import 'link_row_widget.dart';

class MultiMarkerPanel extends StatelessWidget {
  final bool isDesktop;
  final List<MarkerModel> markers;
  final Function(MarkerModel) onMarkerSelected;

  const MultiMarkerPanel({
    super.key,
    required this.isDesktop,
    required this.markers,
    required this.onMarkerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      width: isDesktop ? screenWidth * 0.33 : screenWidth - 40,
      height: screenHeight * 0.85,
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
        mainAxisSize: MainAxisSize.max,
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
          SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (markers.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Zoom in to see reports in this area',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'ChakraPetch',
                        ),
                      ),
                    ),
                  );
                }

                int crossAxisCount = constraints.maxWidth >= 400 ? 2 : 1;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: markers.length,
                  itemBuilder: (context, index) {
                    final marker = markers[index];
                    return InkWell(
                      onTap: () => onMarkerSelected(marker),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: marker.category.color,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            marker.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
