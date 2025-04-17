import 'package:flutter/material.dart';
import 'package:nino_web/models/marker_model.dart';

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

    return Positioned(
      top: 20,
      left: 20,
      right: isDesktop ? null : 20,
      child: Container(
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
                return Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 8,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/nino.png',
                            height: 28,
                            width: 28,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Nino! News Map",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontFamily: 'ChakraPetch',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _LinkText("Terms"),
                        Text("·", style: TextStyle(color: Colors.grey)),
                        _LinkText("Privacy"),
                        Text("·", style: TextStyle(color: Colors.grey)),
                        _LinkText("Download"),
                      ],
                    ),
                  ],
                );
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
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String label;

  const _LinkText(this.label);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implement link navigation logic here if needed
      },
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          fontFamily: 'ChakraPetch',
        ),
      ),
    );
  }
}
