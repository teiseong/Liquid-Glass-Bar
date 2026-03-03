import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'liquid_glass_bar_item.dart';
import 'liquid_glass_bar_style.dart';

/// Internal widget that renders a single navigation bar item.
///
/// Handles the three icon types (SVG, IconData, custom Widget), animated color
/// transitions, bounce scale on selection, and label show/hide animation.
class GlassBarItemWidget extends StatelessWidget {
  final LiquidGlassBarItem item;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;
  final LiquidGlassBarStyle style;

  const GlassBarItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isHighlighted,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = isSelected || isHighlighted;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: style.animationDuration,
          curve: style.animationCurve,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0x00000000),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? style.selectedIconScale : 1.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                child: _buildIcon(isActive),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: isSelected ? 0 : null,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: isSelected ? 0.0 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: AnimatedDefaultTextStyle(
                        duration: style.animationDuration,
                        curve: style.animationCurve,
                        style: style.labelStyle ??
                            TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              height: 16 / 10,
                              color: isActive
                                  ? style.activeColor
                                  : style.inactiveColor,
                            ),
                        child: Text(
                          item.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style.labelStyle != null
                              ? null
                              : TextStyle(
                                  color: isActive
                                      ? style.activeColor
                                      : style.inactiveColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isActive) {
    if (item.iconWidget != null) {
      return SizedBox(
        width: style.iconSize,
        height: style.iconSize,
        child: item.iconWidget!,
      );
    }

    if (item.svgAssetPath != null) {
      return TweenAnimationBuilder<Color?>(
        duration: style.animationDuration,
        curve: style.animationCurve,
        tween: ColorTween(
          begin: style.inactiveColor,
          end: isActive ? style.activeColor : style.inactiveColor,
        ),
        builder: (context, color, child) {
          return SvgPicture.asset(
            item.svgAssetPath!,
            width: style.iconSize,
            height: style.iconSize,
            colorFilter: ColorFilter.mode(
              color ?? style.inactiveColor,
              BlendMode.srcIn,
            ),
          );
        },
      );
    }

    return TweenAnimationBuilder<Color?>(
      duration: style.animationDuration,
      curve: style.animationCurve,
      tween: ColorTween(
        begin: style.inactiveColor,
        end: isActive ? style.activeColor : style.inactiveColor,
      ),
      builder: (context, color, child) {
        return Icon(
          item.iconData,
          size: style.iconSize,
          color: color,
        );
      },
    );
  }
}
