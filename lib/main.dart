import 'package:bitmark_health/app.dart';
import 'package:bitmark_health/app_state_container.dart';
import 'package:flutter/material.dart';


void main() async {
    runApp(new AppStateContainer(
        child: new AppRootWidget(),
    ));
}
