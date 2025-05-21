import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '/core/constants/constants.dart';

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
          LinkText(
            label: "Terms",
            onTap: () => web.window.open(LinkConstants.termsUrl, '_blank'),
          ),
          Text("·", style: TextStyle(color: Colors.grey)),
          LinkText(
            label: "Privacy",
            onTap: () => web.window.open(LinkConstants.privacyUrl, '_blank'),
          ),
          Text("·", style: TextStyle(color: Colors.grey)),
          LinkText(
            label: "Download",
            onTap: () => web.window.open("itms-apps://itunes.apple.com/app/id6741679347", "_blank"),
          ),
        ],
      ),
    );
  }
}

class LinkText extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const LinkText({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
