import 'dart:developer' as devtools show log;
import 'dart:math' show Random;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          textScaler: TextScaler.noScaling,
        ),
      ),
      body: AvailableColorsWidget(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = colors.getRandomElement();
                    });
                  },
                  child: const Text(
                    "Change color 1",
                    textScaler: TextScaler.noScaling,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = colors.getRandomElement();
                    });
                  },
                  child: const Text(
                    "Change color 2",
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ],
            ),
            const ColorsWidget(
              color: AvailableColors.one,
            ),
            const ColorsWidget(
              color: AvailableColors.two,
            ),
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;
  const AvailableColorsWidget({
    super.key,
    required this.color1,
    required this.color2,
    required super.child,
  });

  static AvailableColorsWidget of(
    BuildContext context,
    AvailableColors aspect,
  ) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(
      context,
      aspect: aspect,
    )!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    devtools.log("updateShouldNotify");
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsWidget oldWidget,
      Set<AvailableColors> dependencies) {
    devtools.log("updateShouldNotifyDependent");
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

class ColorsWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorsWidget({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log("Color1 widget");
        break;
      case AvailableColors.two:
        devtools.log("Color2 widget");
        break;
    }

    final provider = AvailableColorsWidget.of(context, color);
    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}

final colors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.brown,
  Colors.purple,
  Colors.orange,
  Colors.grey,
  Colors.pink,
  Colors.yellow,
  Colors.lightGreen,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        Random().nextInt(length),
      );
}
