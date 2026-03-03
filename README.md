# Liquid Glass Bar

[![pub package](https://img.shields.io/pub/v/liquid_glass_bar.svg)](https://pub.dev/packages/liquid_glass_bar)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.32-blue.svg)](https://flutter.dev)

A beautiful iOS-inspired liquid glass bottom navigation bar for Flutter with smooth animations, drag interaction, and glass morphism effects.

**Author:** Tai Thai | [GitHub](https://github.com/teiseong) | [LinkedIn](https://www.linkedin.com/in/taithai1103/) | [Email](mailto:thaithanhtai999@gmail.com)

<!-- Add a screenshot or GIF preview here -->

## Features

- Liquid glass morphism effect powered by `liquid_glass_renderer`
- Smooth sliding indicator that follows the selected tab
- Horizontal drag gesture to switch between tabs
- Animated icon scale bounce on selection
- Animated color transitions for icons and labels
- Support for **SVG assets**, **IconData**, and **custom Widget** icons
- Fully customizable styling via `LiquidGlassBarStyle`
- Dynamic item count (2 or more items)

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  liquid_glass_bar: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:liquid_glass_bar/liquid_glass_bar.dart';

Scaffold(
  extendBody: true,
  body: pages[_currentIndex],
  bottomNavigationBar: LiquidGlassBar(
    items: const [
      LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
      LiquidGlassBarItem(iconData: Icons.search, label: 'Search'),
      LiquidGlassBarItem(iconData: Icons.person, label: 'Profile'),
    ],
    currentIndex: _currentIndex,
    onTap: (index) => setState(() => _currentIndex = index),
  ),
);
```

## API Reference

### LiquidGlassBar

The main widget. Place it as the `bottomNavigationBar` of a `Scaffold`.

| Parameter      | Type                          | Required | Description                                |
| -------------- | ----------------------------- | -------- | ------------------------------------------ |
| `items`        | `List<LiquidGlassBarItem>` | Yes      | Navigation items (minimum 2)               |
| `currentIndex` | `int`                         | Yes      | Currently selected item index              |
| `onTap`        | `ValueChanged<int>`           | Yes      | Callback when an item is tapped or dragged |
| `style`        | `LiquidGlassBarStyle?`     | No       | Style customization                        |

### LiquidGlassBarItem

Data model for each navigation item. At least one icon source must be provided.

| Parameter      | Type       | Description              |
| -------------- | ---------- | ------------------------ |
| `svgAssetPath` | `String?`  | Path to an SVG asset     |
| `iconData`     | `IconData?`| Material/Cupertino icon  |
| `iconWidget`   | `Widget?`  | Custom widget icon       |
| `label`        | `String`   | Text label for the item  |

### LiquidGlassBarStyle

Full style customization for the navigation bar.

| Property              | Type                  | Default                              |
| --------------------- | --------------------- | ------------------------------------ |
| `liquidGlassSettings` | `LiquidGlassSettings?`| Built-in defaults                    |
| `activeColor`         | `Color`               | `Color(0xFF10B981)` (emerald)        |
| `inactiveColor`       | `Color`               | `Color(0xFFA1A1AA)` (neutral gray)   |
| `borderRadius`        | `double`              | `32`                                 |
| `height`              | `double`              | `57`                                 |
| `padding`             | `EdgeInsets`          | `EdgeInsets.fromLTRB(20, 12, 20, 32)`|
| `animationDuration`   | `Duration`            | `250ms`                              |
| `animationCurve`      | `Curve`               | `Curves.easeOutQuad`                 |
| `iconSize`            | `double`              | `24`                                 |
| `selectedIconScale`   | `double`              | `1.2`                                |
| `labelStyle`          | `TextStyle?`          | `null` (uses built-in style)         |

## Customization

### Style Properties

```dart
LiquidGlassBar(
  items: items,
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  style: LiquidGlassBarStyle(
    activeColor: Colors.blue,
    inactiveColor: Colors.grey,
    borderRadius: 24,
    height: 60,
    iconSize: 28,
    selectedIconScale: 1.3,
    animationDuration: Duration(milliseconds: 300),
    padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
  ),
);
```

### Glass Effect Settings

Control the liquid glass appearance via `liquidGlassSettings`. No extra import needed — `LiquidGlassSettings` is re-exported from this package.

```dart
LiquidGlassBar(
  items: items,
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  style: LiquidGlassBarStyle(
    activeColor: Colors.blue,
    liquidGlassSettings: LiquidGlassSettings(
      thickness: 20.0,          // Glass layer thickness
      blur: 16.0,               // Background blur amount
      glassColor: Colors.white.withValues(alpha: 0.8), // Glass tint color
      lightIntensity: 0.6,      // Specular light brightness
      refractiveIndex: 1.5,     // Light refraction amount
    ),
  ),
);
```

| Property         | Type     | Default | Description                              |
| ---------------- | -------- | ------- | ---------------------------------------- |
| `thickness`      | `double` | `20.0`  | Thickness of the glass layer             |
| `blur`           | `double` | `16.0`  | Background blur intensity                |
| `glassColor`     | `Color`  | White 80% opacity | Tint color of the glass     |
| `lightIntensity` | `double` | `0.6`   | Brightness of the specular light effect  |
| `refractiveIndex`| `double` | `1.5`   | How much light bends through the glass   |

## Requirements

- Flutter 3.32+
- Dart 3.10+

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on [GitHub](https://github.com/teiseong/liquid-glass-bar).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
