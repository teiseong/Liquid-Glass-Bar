import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_bar/liquid_glass_bar.dart';

void main() {
  final testItems = [
    const LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
    const LiquidGlassBarItem(iconData: Icons.search, label: 'Search'),
    const LiquidGlassBarItem(iconData: Icons.person, label: 'Profile'),
  ];

  Widget buildApp({
    required int currentIndex,
    ValueChanged<int>? onTap,
    LiquidGlassBarStyle? style,
    List<LiquidGlassBarItem>? items,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: const SizedBox.expand(),
        bottomNavigationBar: LiquidGlassBar(
          items: items ?? testItems,
          currentIndex: currentIndex,
          onTap: onTap ?? (_) {},
          style: style,
        ),
      ),
    );
  }

  // --- Stateful wrapper for tests that need to change currentIndex ---
  Widget buildStatefulApp({
    int initialIndex = 0,
    List<LiquidGlassBarItem>? items,
    LiquidGlassBarStyle? style,
  }) {
    return MaterialApp(
      home: _StatefulNavBarHost(
        items: items ?? testItems,
        initialIndex: initialIndex,
        style: style,
      ),
    );
  }

  group('Rendering', () {
    testWidgets('renders correct number of item labels', (tester) async {
      await tester.pumpWidget(buildApp(currentIndex: 0));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('renders icon for each item', (tester) async {
      await tester.pumpWidget(buildApp(currentIndex: 0));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders iconWidget when provided', (tester) async {
      final items = [
        LiquidGlassBarItem(
          iconWidget: Container(key: const Key('custom-icon')),
          label: 'Custom',
        ),
        const LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
      ];

      await tester.pumpWidget(buildApp(currentIndex: 0, items: items));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('custom-icon')), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('renders mixed icon types in the same bar', (tester) async {
      final mixedItems = [
        const LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
        LiquidGlassBarItem(
          iconWidget: Container(key: const Key('widget-icon')),
          label: 'Widget',
        ),
        const LiquidGlassBarItem(iconData: Icons.settings, label: 'Settings'),
      ];

      await tester.pumpWidget(buildApp(currentIndex: 0, items: mixedItems));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byKey(const Key('widget-icon')), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  group('Tap interaction', () {
    testWidgets('tap triggers onTap with correct index', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(buildApp(
        currentIndex: 0,
        onTap: (index) => tappedIndex = index,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search'));
      expect(tappedIndex, 1);

      await tester.tap(find.text('Profile'));
      expect(tappedIndex, 2);

      // Home label is hidden when selected, so tap via its icon
      await tester.tap(find.byIcon(Icons.home));
      expect(tappedIndex, 0);
    });

    testWidgets('tapping already-selected item still fires onTap',
        (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(buildApp(
        currentIndex: 1,
        onTap: (index) => tappedIndex = index,
      ));
      await tester.pumpAndSettle();

      // Label is hidden for selected item, tap icon instead
      await tester.tap(find.byIcon(Icons.search));
      expect(tappedIndex, 1);
    });
  });

  group('Drag interaction', () {
    testWidgets('horizontal drag right selects next item', (tester) async {
      await tester.pumpWidget(buildStatefulApp(initialIndex: 0));
      await tester.pumpAndSettle();

      // Find the nav bar to perform the drag on
      final navBar = find.byType(LiquidGlassBar);
      expect(navBar, findsOneWidget);

      // Drag from left to right across the bar
      await tester.drag(navBar, const Offset(200, 0));
      await tester.pumpAndSettle();

      // The stateful host should have updated the index
      final state = tester.state<_StatefulNavBarHostState>(
        find.byType(_StatefulNavBarHost),
      );
      expect(state.currentIndex, greaterThan(0));
    });

    testWidgets('horizontal drag left selects previous item', (tester) async {
      await tester.pumpWidget(buildStatefulApp(initialIndex: 2));
      await tester.pumpAndSettle();

      final navBar = find.byType(LiquidGlassBar);

      // Drag from right to left
      await tester.drag(navBar, const Offset(-200, 0));
      await tester.pumpAndSettle();

      final state = tester.state<_StatefulNavBarHostState>(
        find.byType(_StatefulNavBarHost),
      );
      expect(state.currentIndex, lessThan(2));
    });
  });

  group('Index change', () {
    testWidgets('changing currentIndex updates the UI', (tester) async {
      await tester.pumpWidget(buildStatefulApp(initialIndex: 0));
      await tester.pumpAndSettle();

      // Tap on the second item to change index
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      final state = tester.state<_StatefulNavBarHostState>(
        find.byType(_StatefulNavBarHost),
      );
      expect(state.currentIndex, 1);
    });
  });

  group('Item count support', () {
    testWidgets('supports 2-item minimum', (tester) async {
      final twoItems = [
        const LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
        const LiquidGlassBarItem(
          iconData: Icons.settings,
          label: 'Settings',
        ),
      ];

      await tester.pumpWidget(buildApp(currentIndex: 0, items: twoItems));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('supports 5 items', (tester) async {
      final fiveItems = [
        const LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
        const LiquidGlassBarItem(iconData: Icons.search, label: 'Search'),
        const LiquidGlassBarItem(iconData: Icons.add, label: 'Add'),
        const LiquidGlassBarItem(iconData: Icons.chat, label: 'Chat'),
        const LiquidGlassBarItem(iconData: Icons.person, label: 'Profile'),
      ];

      await tester.pumpWidget(buildApp(currentIndex: 0, items: fiveItems));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('tap works correctly with 5 items', (tester) async {
      int? tappedIndex;
      final fiveItems = [
        const LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
        const LiquidGlassBarItem(iconData: Icons.search, label: 'Search'),
        const LiquidGlassBarItem(iconData: Icons.add, label: 'Add'),
        const LiquidGlassBarItem(iconData: Icons.chat, label: 'Chat'),
        const LiquidGlassBarItem(iconData: Icons.person, label: 'Profile'),
      ];

      await tester.pumpWidget(buildApp(
        currentIndex: 0,
        items: fiveItems,
        onTap: (index) => tappedIndex = index,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chat'));
      expect(tappedIndex, 3);

      await tester.tap(find.text('Profile'));
      expect(tappedIndex, 4);
    });
  });

  group('Style', () {
    testWidgets('works with custom style', (tester) async {
      await tester.pumpWidget(buildApp(
        currentIndex: 1,
        style: const LiquidGlassBarStyle(
          activeColor: Color(0xFF0000FF),
          inactiveColor: Color(0xFF888888),
          iconSize: 28,
          height: 64,
          borderRadius: 16,
          selectedIconScale: 1.5,
          animationDuration: Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          padding: EdgeInsets.all(16),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(LiquidGlassBar), findsOneWidget);
    });

    testWidgets('works with custom labelStyle', (tester) async {
      await tester.pumpWidget(buildApp(
        currentIndex: 0,
        style: const LiquidGlassBarStyle(
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(LiquidGlassBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('LiquidGlassBarItem', () {
    test('requires at least one icon source', () {
      expect(
        () => LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
        returnsNormally,
      );

      expect(
        () => LiquidGlassBarItem(
          svgAssetPath: 'assets/icon.svg',
          label: 'SVG',
        ),
        returnsNormally,
      );

      expect(
        () => LiquidGlassBarItem(
          iconWidget: const SizedBox(),
          label: 'Custom',
        ),
        returnsNormally,
      );
    });

    test('allows multiple icon sources simultaneously', () {
      expect(
        () => LiquidGlassBarItem(
          iconData: Icons.home,
          svgAssetPath: 'assets/icon.svg',
          label: 'Both',
        ),
        returnsNormally,
      );
    });

    test('stores label correctly', () {
      const item = LiquidGlassBarItem(
        iconData: Icons.home,
        label: 'My Label',
      );
      expect(item.label, 'My Label');
      expect(item.iconData, Icons.home);
      expect(item.svgAssetPath, isNull);
      expect(item.iconWidget, isNull);
    });
  });

  group('LiquidGlassBarStyle', () {
    test('has sensible defaults', () {
      const style = LiquidGlassBarStyle();

      expect(style.activeColor, const Color(0xFF10B981));
      expect(style.inactiveColor, const Color(0xFFA1A1AA));
      expect(style.borderRadius, 32);
      expect(style.height, 57);
      expect(style.iconSize, 24);
      expect(style.selectedIconScale, 1.2);
      expect(style.animationDuration, const Duration(milliseconds: 250));
      expect(style.animationCurve, Curves.easeOutQuad);
      expect(style.liquidGlassSettings, isNull);
      expect(style.labelStyle, isNull);
      expect(style.padding, const EdgeInsets.fromLTRB(20, 12, 20, 32));
    });

    test('accepts custom values', () {
      const style = LiquidGlassBarStyle(
        activeColor: Color(0xFFFF0000),
        inactiveColor: Color(0xFF00FF00),
        borderRadius: 16,
        height: 64,
        iconSize: 32,
        selectedIconScale: 1.5,
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.bounceIn,
        padding: EdgeInsets.zero,
      );

      expect(style.activeColor, const Color(0xFFFF0000));
      expect(style.inactiveColor, const Color(0xFF00FF00));
      expect(style.borderRadius, 16);
      expect(style.height, 64);
      expect(style.iconSize, 32);
      expect(style.selectedIconScale, 1.5);
      expect(style.animationDuration, const Duration(milliseconds: 500));
      expect(style.animationCurve, Curves.bounceIn);
      expect(style.padding, EdgeInsets.zero);
    });
  });
}

// ---------------------------------------------------------------------------
// Stateful wrapper so tests can verify index changes after taps/drags.
// ---------------------------------------------------------------------------
class _StatefulNavBarHost extends StatefulWidget {
  final List<LiquidGlassBarItem> items;
  final int initialIndex;
  final LiquidGlassBarStyle? style;

  const _StatefulNavBarHost({
    required this.items,
    this.initialIndex = 0,
    this.style,
  });

  @override
  State<_StatefulNavBarHost> createState() => _StatefulNavBarHostState();
}

class _StatefulNavBarHostState extends State<_StatefulNavBarHost> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SizedBox.expand(),
      bottomNavigationBar: LiquidGlassBar(
        items: widget.items,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        style: widget.style,
      ),
    );
  }
}
