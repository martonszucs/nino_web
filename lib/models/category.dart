import 'package:flutter/material.dart';

enum MarkerCategory {
  pov,
  help,
  dislike,
  protest,
  people,
  event,
  emergency,
  fire,
  danger,
  custom
}

extension MarkerCategoryColor on MarkerCategory {
  Color get color {
    switch (this) {
      case MarkerCategory.pov:
      case MarkerCategory.help:
      case MarkerCategory.dislike:
      case MarkerCategory.custom:
        return Color(0xFF108CFF);
      case MarkerCategory.protest:
      case MarkerCategory.people:
      case MarkerCategory.event:
        return Color(0xFFBC09FB);
      case MarkerCategory.emergency:
      case MarkerCategory.fire:
      case MarkerCategory.danger:
        return Color(0xFFFF0F47);
    }
  }

  static MarkerCategory fromString(String value) {
    String valueLowerCase = value.toLowerCase();
    try {
      return MarkerCategory.values.firstWhere(
        (e) => e.toString().split('.').last == valueLowerCase,
      );
    } catch (e) {
      return MarkerCategory.custom;
    }
  }
}
