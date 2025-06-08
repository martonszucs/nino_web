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
    return Container(
      width: isDesktop ? 400 : MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: markers.length,
              itemBuilder: (context, index) {
                final marker = markers[index];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(marker.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: marker.category.color,
                        width: 2,
                      ),
                    ),
                  ),
                  title: Text('${marker.category.toString().split('.').last} - ${marker.timestamp}'),
                  subtitle: Text(marker.authorId),
                  onTap: () => onMarkerSelected(marker),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
