import 'package:flutter/material.dart';

class LinkRow extends StatelessWidget {
  final Alignment alignment;

  const LinkRow({super.key, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          LinkText("Terms"),
          Text("·", style: TextStyle(color: Colors.grey)),
          LinkText("Privacy"),
          Text("·", style: TextStyle(color: Colors.grey)),
          LinkText("Download"),
        ],
      ),
    );
  }
}

class LinkText extends StatelessWidget {
  final String label;

  const LinkText(this.label, {super.key});

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
