import 'package:bitmark_health/screens/base_screen.dart';
import 'package:bitmark_health/services/bitmark_SDK.dart';
import 'package:bitmark_health/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class MockScreen extends StatefulWidget with BaseScreen {
    MockScreen({BuildContext context}) {
        this.context = context;
        this.appState = this.getAppState(context);
    }

    @override
    MockScreenState createState() => new MockScreenState();
}

class MockScreenState extends State<MockScreen> {

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text('Mock'),
            ),
            body: Center(
                child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
        );
    }
}
