import 'package:bitmark_health/screens/mock_screen.dart';
import 'package:bitmark_health/screens/onboarding/create_account_screen.dart';
import 'package:bitmark_health/screens/user/home_screen.dart';
import 'package:bitmark_health/screens/user/settings_screen.dart';
import 'package:bitmark_health/screens/user/user_screen.dart';
import 'package:bitmark_health/services/bitmark_SDK.dart';
import 'package:flutter/material.dart';
import 'package:bitmark_health/configs/configs.dart' as CONFIG;

class AppRootWidget extends StatefulWidget {
    @override
    AppRootWidgetState createState() => new AppRootWidgetState();
}

class AppRootWidgetState extends State<AppRootWidget> {
    ThemeData get _themeData => new ThemeData(
        primaryColor: Colors.cyan,
        accentColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[300],
    );

    @override
  void initState() {
    super.initState();
    BitmarkSDK.initialize(CONFIG.config["apiKey"], CONFIG.config["network"]);
  }

    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: 'Bitmark Health',
            routes: {
                '/': (BuildContext context) => new HomeScreen(context: context),
                '/createAccount': (BuildContext context) => new CreateAccountScreen(context: context),
                '/user': (BuildContext context) => new UserScreen(context: context),
                '/settings': (BuildContext context) => new SettingsScreen(context: context),
                '/mock': (BuildContext context) => new MockScreen(context: context),
            },
        );
    }
}