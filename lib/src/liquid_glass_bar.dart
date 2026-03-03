import 'package:flutter/widgets.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import 'liquid_glass_bar_item.dart';
import 'liquid_glass_bar_style.dart';
import 'glass_bar_item_widget.dart';

/// A beautiful iOS-inspired liquid glass bottom navigation bar with smooth
/// animations, drag interaction, and glass morphism effects.
///
/// {@tool snippet}
/// ```dart
/// LiquidGlassBar(
///   items: [
///     LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
///     LiquidGlassBarItem(iconData: Icons.search, label: 'Search'),
///     LiquidGlassBarItem(iconData: Icons.person, label: 'Profile'),
///   ],
///   currentIndex: _selectedIndex,
///   onTap: (index) => setState(() => _selectedIndex = index),
/// )
/// ```
/// {@end-tool}
class LiquidGlassBar extends StatefulWidget {
  /// The list of navigation items to display.
  ///
  /// Must contain at least 2 items.
  final List<LiquidGlassBarItem> items;

  /// The index of the currently selected item.
  final int currentIndex;

  /// Called when an item is tapped or the drag gesture selects an item.
  final ValueChanged<int> onTap;

  /// Optional style configuration. Uses sensible defaults when not provided.
  final LiquidGlassBarStyle? style;

  const LiquidGlassBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.style,
  }) : assert(items.length >= 2, 'At least 2 items are required.');

  @override
  State<LiquidGlassBar> createState() => _LiquidGlassBarState();
}

class _LiquidGlassBarState extends State<LiquidGlassBar> {
  double? _dragAlignment;
  bool _isDragging = false;
  int? _highlightedIndex;

  LiquidGlassBarStyle get _style =>
      widget.style ?? const LiquidGlassBarStyle();

  int get _lastIndex => widget.items.length - 1;

  double _getAlignment(int index) {
    if (_lastIndex == 0) return 0.0;
    return -1.0 + (index * 2 / _lastIndex);
  }

  void _updateHighlightedIndex() {
    if (!_isDragging || _dragAlignment == null) {
      _highlightedIndex = null;
      return;
    }

    final normalized = (_dragAlignment! + 1) / 2;
    final index = (normalized * _lastIndex).round();
    _highlightedIndex = index.clamp(0, _lastIndex);
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final itemCount = widget.items.length;

    return Container(
      padding: style.padding,
      child: Stack(
        children: [
          // Shadow for contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(style.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
            ),
          ),
          // Liquid Glass Content
          LiquidGlass.withOwnLayer(
            shape: LiquidRoundedRectangle(borderRadius: style.borderRadius),
            settings: style.liquidGlassSettings ??
                LiquidGlassSettings(
                  thickness: 20.0,
                  blur: 16.0,
                  glassColor: const Color(0xCCFFFFFF),
                  lightIntensity: 0.6,
                  refractiveIndex: 1.5,
                ),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / itemCount;
                  final totalDragWidth = constraints.maxWidth - itemWidth;

                  return GestureDetector(
                    onHorizontalDragStart: (details) {
                      setState(() {
                        _isDragging = true;
                        _dragAlignment = _getAlignment(widget.currentIndex);
                        _updateHighlightedIndex();
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      if (!_isDragging) return;
                      setState(() {
                        final deltaAlignment =
                            (details.primaryDelta! / totalDragWidth) * 2.0;
                        _dragAlignment =
                            (_dragAlignment! + deltaAlignment).clamp(-1.0, 1.0);
                        _updateHighlightedIndex();
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        _isDragging = false;
                        _highlightedIndex = null;

                        final currentA = _dragAlignment!;
                        final normalized = (currentA + 1) / 2;
                        final nearestIndex = (normalized * _lastIndex).round();

                        widget.onTap(nearestIndex);
                      });
                    },
                    onHorizontalDragCancel: () {
                      setState(() {
                        _isDragging = false;
                        _highlightedIndex = null;
                      });
                    },
                    child: SizedBox(
                      height: style.height,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Sliding Indicator
                          AnimatedAlign(
                            duration: _isDragging
                                ? Duration.zero
                                : style.animationDuration,
                            curve: style.animationCurve,
                            alignment: Alignment(
                              _isDragging
                                  ? _dragAlignment!
                                  : _getAlignment(widget.currentIndex),
                              0,
                            ),
                            child: Container(
                              width: itemWidth,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    style.activeColor.withValues(alpha: 0.15),
                                    const Color(0x4DFFFFFF),
                                    const Color(0x1AFFFFFF),
                                  ],
                                  stops: const [0.0, 0.4, 1.0],
                                ),
                                border: Border.all(
                                  color: const Color(0x99FFFFFF),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        style.activeColor.withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                  const BoxShadow(
                                    color: Color(0xCCFFFFFF),
                                    blurRadius: 8,
                                    offset: Offset(-2, -2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          // Nav Items
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = 0; i < itemCount; i++)
                                GlassBarItemWidget(
                                  item: widget.items[i],
                                  isSelected: widget.currentIndex == i,
                                  isHighlighted: _highlightedIndex == i,
                                  onTap: () => widget.onTap(i),
                                  style: style,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Border Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(style.borderRadius),
                  border: Border.all(
                    color: const Color(0xE6FFFFFF),
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
