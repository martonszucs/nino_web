import 'package:flutter/material.dart';

class SidePanel extends StatelessWidget {
  final bool isDesktop;

  const SidePanel({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      right: isDesktop ? null : 20,
      child: Container(
        width: isDesktop ? MediaQuery.of(context).size.width * 0.33 : null,
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
          children: [
            Text(
              "Side Panel",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("This is an example side panel."),
          ],
        ),
      ),
    );
  }
}