import 'package:flutter/material.dart';
import 'package:nino_web/models/category.dart';
import '/models/marker_model.dart';

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
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/nino.png',
                    height: 32,
                    width: 32,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Recent Activity",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontFamily: 'ChakraPetch',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
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
