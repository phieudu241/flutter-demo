import 'package:bitmark_health/models/app_state.dart';
import 'package:bitmark_health/models/user.dart';
import 'package:bitmark_health/services/bitmark_SDK.dart';
import 'package:bitmark_health/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bitmark_health/configs/configs.dart' as CONFIG;

class AppStateContainer extends StatefulWidget {
    final AppState state;
    final Widget child;

    AppStateContainer({
        @required this.child,
        this.state,
    });

    // This creates a method on the AppState that's just like 'of'
    // On MediaQueries, Theme, etc
    // This is the secret to accessing your AppState all over your app
    static _AppStateContainerState of(BuildContext context) {
        return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
        as _InheritedStateContainer)
            .data;
    }

    @override
    _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
    AppState state;
    User user;

    @override
    void initState() {
        super.initState();
        if (widget.state != null) {
            state = widget.state;
        } else {
            state = new AppState.loading();
            initAppData();
        }
    }

    initAppData() async {
        CONFIG.configure();
        await LocalStorageService.init();
        await initUser();
    }

    initUser() async {
        user = LocalStorageService.getUser();
        if (user != null) {
            var authenticate = await BitmarkSDK.authenticate();
            print(authenticate);
            setState(() {
                state.user = user;
                state.isLoading = false;
            });
        } else {
            setState(() {
                state.isLoading = false;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return new _InheritedStateContainer(
            data: this,
            child: widget.child,
        );
    }
}

class _InheritedStateContainer extends InheritedWidget {
    final _AppStateContainerState data;

    _InheritedStateContainer({
        Key key,
        @required this.data,
        @required Widget child,
    }) : super(key: key, child: child);

    @override
    bool updateShouldNotify(_InheritedStateContainer old) {
        print("old: $old");
        return true;
    }
}