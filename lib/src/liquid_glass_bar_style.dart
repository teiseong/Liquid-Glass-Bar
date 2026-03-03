import 'package:flutter/widgets.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Style configuration for [LiquidGlassBar].
///
/// All properties have sensible defaults and can be selectively overridden.
class LiquidGlassBarStyle {
  /// Settings passed through to [LiquidGlass.withOwnLayer].
  ///
  /// Controls glass thickness, blur, color, light intensity, and refractive index.
  final LiquidGlassSettings? liquidGlassSettings;

  /// Color used for the selected/highlighted item icon and label.
  ///
  /// Defaults to `Color(0xFF10B981)` (emerald green).
  final Color activeColor;

  /// Color used for unselected item icons and labels.
  ///
  /// Defaults to `Color(0xFFA1A1AA)` (neutral gray).
  final Color inactiveColor;

  /// Border radius of the outer navigation bar container.
  ///
  /// Defaults to `32`.
  final double borderRadius;

  /// Height of the inner navigation bar content area.
  ///
  /// Defaults to `57`.
  final double height;

  /// Outer padding around the navigation bar.
  ///
  /// Defaults to `EdgeInsets.fromLTRB(20, 12, 20, 32)`.
  final EdgeInsets padding;

  /// Duration of the sliding indicator animation.
  ///
  /// Defaults to `Duration(milliseconds: 250)`.
  final Duration animationDuration;

  /// Curve of the sliding indicator animation.
  ///
  /// Defaults to `Curves.easeOutQuad`.
  final Curve animationCurve;

  /// Size of the icon (width and height).
  ///
  /// Defaults to `24`.
  final double iconSize;

  /// Scale factor applied to the selected item's icon (bounce effect).
  ///
  /// Defaults to `1.2`.
  final double selectedIconScale;

  /// Optional text style override for the item labels.
  final TextStyle? labelStyle;

  const LiquidGlassBarStyle({
    this.liquidGlassSettings,
    this.activeColor = const Color(0xFF10B981),
    this.inactiveColor = const Color(0xFFA1A1AA),
    this.borderRadius = 32,
    this.height = 57,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 32),
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOutQuad,
    this.iconSize = 24,
    this.selectedIconScale = 1.2,
    this.labelStyle,
  });
}
