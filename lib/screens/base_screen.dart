import 'package:bitmark_health/app_state_container.dart';
import 'package:bitmark_health/models/app_state.dart';
import 'package:flutter/material.dart';

abstract class BaseScreen {
    BuildContext context;
    AppState appState;

    AppState getAppState(BuildContext context) {
        var container = AppStateContainer.of(context);
        return container.state;
    }
}