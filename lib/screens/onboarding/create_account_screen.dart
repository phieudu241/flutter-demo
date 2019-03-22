import 'package:bitmark_health/models/user.dart';
import 'package:bitmark_health/screens/base_screen.dart';
import 'package:bitmark_health/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:bitmark_health/services/bitmark_SDK.dart';

class CreateAccountScreen extends StatelessWidget with BaseScreen {
    CreateAccountScreen({BuildContext context}) {
        this.context = context;
        this.appState = this.getAppState(context);
    }

    @override
    Widget build(BuildContext context) {
        _createNewAccount() async {
            var result = await BitmarkSDK.createAccount(false);

            if (result["status"] == "OK") {
                var accountInfo = await BitmarkSDK.getAccountInfo();
                if (accountInfo["status"] == "OK") {
                    String accountNumber = accountInfo["data"][0];
                    print(accountNumber);
                    User user = User.fromBitmarkAccountNumber(accountNumber);
                    await LocalStorageService.setUser(user);
                    this.appState.user = user;
                    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
                }
            }
        }

        return Scaffold(
            appBar: AppBar(
                title: Text("Create New Account"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        RaisedButton(
                            onPressed: _createNewAccount,
                            textColor: Colors.white,
                            color: Colors.blue,
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                                "Create New Account",
                            ),
                        ),
                    ],
                ),
            ));
    }
}
