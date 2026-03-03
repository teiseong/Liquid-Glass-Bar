import 'package:flutter/material.dart';
import 'package:liquid_glass_bar/liquid_glass_bar.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass Nav Bar Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF10B981),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _items = [
    LiquidGlassBarItem(iconData: Icons.home_rounded, label: 'Home'),
    LiquidGlassBarItem(iconData: Icons.search_rounded, label: 'Search'),
    LiquidGlassBarItem(
      iconData: Icons.bookmark_rounded,
      label: 'Collections',
    ),
    LiquidGlassBarItem(iconData: Icons.public_rounded, label: 'Community'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _PageContent(title: 'Home', color: Colors.teal.shade50),
          _PageContent(title: 'Search', color: Colors.blue.shade50),
          _PageContent(title: 'Collections', color: Colors.purple.shade50),
          _PageContent(title: 'Community', color: Colors.orange.shade50),
        ],
      ),
      bottomNavigationBar: LiquidGlassBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        // Uncomment to customize the style:
        // style: LiquidGlassBarStyle(
        //   activeColor: Colors.blue,
        //   inactiveColor: Colors.grey,
        //   borderRadius: 24,
        //   height: 60,
        // ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final String title;
  final Color color;

  const _PageContent({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
