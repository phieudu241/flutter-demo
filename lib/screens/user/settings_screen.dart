import 'package:bitmark_health/screens/base_screen.dart';
import 'package:bitmark_health/services/bitmark_SDK.dart';
import 'package:bitmark_health/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget with BaseScreen {
    SettingsScreen({BuildContext context}) {
        this.context = context;
        this.appState = this.getAppState(context);
    }

    @override
    SettingsScreenState createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
    _logout() async {
        await BitmarkSDK.logout();
        await LocalStorageService.logoutUser();
        widget.appState.user = null;

        Navigator.pushNamedAndRemoveUntil(widget.context, "/", (_) => false);
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text('Settings'),
            ),
            body: Center(
                child: RaisedButton(
                    onPressed: () => _logout(),
                    textColor: Colors.white,
                    color: Colors.blue,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                        "Logout",
                    ),
                ),
            ));
    }
}
