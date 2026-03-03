import 'package:flutter/widgets.dart';

/// Data model for a single navigation bar item.
///
/// At least one of [svgAssetPath], [iconData], or [iconWidget] must be provided.
class LiquidGlassBarItem {
  /// SVG icon asset path (e.g. 'assets/icons/home.svg').
  final String? svgAssetPath;

  /// Material or Cupertino icon data.
  final IconData? iconData;

  /// Custom widget to use as the icon.
  final Widget? iconWidget;

  /// Text label displayed below the icon.
  final String label;

  const LiquidGlassBarItem({
    this.svgAssetPath,
    this.iconData,
    this.iconWidget,
    required this.label,
  }) : assert(
         svgAssetPath != null || iconData != null || iconWidget != null,
         'At least one of svgAssetPath, iconData, or iconWidget must be provided.',
       );
}
