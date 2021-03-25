import 'package:bapp/config/theme_config.dart';
import 'package:bapp/super_strapi/my_strapi/defaultDataX.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

enum BappChangeThemeEvent { change }

class BappThemedApp extends StatefulWidget {
  final Widget child;

  const BappThemedApp({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  _BappThemedAppState createState() => _BappThemedAppState();

  static bool isDarkTheme(BuildContext context) {
    return context
            .findAncestorStateOfType<_BappThemedAppState>()
            ?._isDarkTheme ??
        false;
  }

  static void switchTheme(BuildContext context) {
    return context
        .findAncestorStateOfType<_BappThemedAppState>()
        ?._switchTheme();
  }
}

class _BappThemedAppState extends State<BappThemedApp> {
  Brightness? brightness;

  bool get _isDarkTheme => brightness == Brightness.dark;

  void _switchTheme() {
    setState(() {
      _updateTheme(dark: !(brightness == Brightness.dark));
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future _init() async {
    final dark = await DefaultDataX.i
        .getValue("dark", defaultValue: brightness == Brightness.dark);
    if (dark is bool) {
      setState(() {
        _updateTheme(dark: dark);
      });
    }
  }

  Future _saveTheme(bool dark) async {
    final box = await Hive.openLazyBox("brightness.box");
    box.put("dark", dark);
  }

  void _updateTheme({required bool dark}) {
    if (dark) {
      if (brightness != Brightness.dark) {
        brightness = Brightness.dark;
      }
    } else {
      if (brightness != Brightness.light) {
        brightness = Brightness.light;
      }
    }
    _saveTheme(dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bapp: the booking app",
      debugShowCheckedModeBanner: false,
      themeMode: brightness == null
          ? ThemeMode.system
          : (brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light),
      theme: getLightThemeData(),
      darkTheme: getDarkThemeData(),
      home: widget.child,
    );
  }
}
