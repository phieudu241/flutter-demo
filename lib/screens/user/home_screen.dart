import 'package:bitmark_health/models/app_state.dart';
import 'package:bitmark_health/screens/base_screen.dart';
import 'package:bitmark_health/screens/onboarding/create_account_screen.dart';
import 'package:bitmark_health/screens/user/user_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget with BaseScreen {
    HomeScreen({BuildContext context}) {
        this.context = context;
        this.appState = this.getAppState(context);
    }

    @override
    HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
    @override
    Widget build(BuildContext context) {
        AppState appState = widget.appState;

        Widget _loadingView() {
            return new Center(
                child: new CircularProgressIndicator(),
            );
        }

        Widget _pageToDisplay() {
            if (appState.isLoading) {
                return _loadingView();
            } else if (!appState.isLoading && appState.user == null) {
                return new CreateAccountScreen(context: context);
            } else {
                return new UserScreen(context: context);
            }
        }

        return _pageToDisplay();
    }
}
