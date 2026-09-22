import 'package:flutter/material.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';

/// Maps a backend `AppModule.icon` name (as seeded in univalle-api, e.g.
/// "notebook-text") to the matching local SVG asset. Falls back to a
/// generic icon for names the app doesn't ship yet, so an unrecognized
/// server-sent module degrades gracefully instead of crashing.
String moduleIconAsset(String icon) {
  const icons = {
    'notebook-text': AssetPaths.iconNotebook,
    'id-card': AssetPaths.iconIdCard,
    'layers': AssetPaths.iconLayers,
    'route': AssetPaths.iconRoute,
    'star': AssetPaths.iconStar,
    'calendar': AssetPaths.iconCalendar,
    'library': AssetPaths.iconLibrary,
    'utensils': AssetPaths.iconUtensils,
    'newspaper': AssetPaths.iconNewspaper,
  };
  return icons[icon] ?? AssetPaths.iconLink;
}

/// Parses a backend `AppModule.color` hex string (`#RRGGBB`). Falls back to
/// [AppColors.univalleRed] for a missing or malformed value — this is a
/// runtime parse of server data, not a hardcoded literal, so it doesn't
/// violate the "colors only from AppColors" convention.
Color moduleColor(String hex) {
  final match = RegExp(r'^#([0-9A-Fa-f]{6})$').firstMatch(hex);
  if (match == null) return AppColors.univalleRed;
  return Color(int.parse('FF${match.group(1)}', radix: 16));
}
