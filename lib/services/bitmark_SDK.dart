import 'package:flutter/services.dart';

class BitmarkSDK {
    static const bitmarkSDK = const MethodChannel('bitmark.com/bitmarkSDK');

    static initialize(String apiKey, String network) async {
        String methodName = 'initialize';
        try {
            return await bitmarkSDK.invokeMethod(methodName, {"apiKey": apiKey, "network": network});
        } on PlatformException catch (e) {
            var message = "Failed to execute $methodName: '${e.message}'.";
            print(message);
        }
    }

    static createAccount(bool authentication) async {
        String methodName = 'createAccount';
        try {
            return await bitmarkSDK.invokeMethod(methodName, authentication);
        } on PlatformException catch (e) {
            var message = "Failed to execute $methodName: '${e.message}'.";
            print(message);
        }
    }

    static getAccountInfo() async {
        String methodName = 'accountInfo';
        try {
            return await bitmarkSDK.invokeMethod(methodName);
        } on PlatformException catch (e) {
            var message = "Failed to execute $methodName: '${e.message}'.";
            print(message);
        }
    }

    static authenticate() async {
        String methodName = 'authenticate';
        String message = 'Your fingerprint signature is required.';
        try {
            return await bitmarkSDK.invokeMethod(methodName, message);
        } on PlatformException catch (e) {
            var message = "Failed to execute $methodName: '${e.message}'.";
            print(message);
        }
    }

    static logout() async {
        String methodName = 'removeAccount';
        try {
            return await bitmarkSDK.invokeMethod(methodName);
        } on PlatformException catch (e) {
            var message = "Failed to execute $methodName: '${e.message}'.";
            print(message);
        }
    }

    static issue(issueParam) async {
        String methodName = 'issue';
        try {
            return await bitmarkSDK.invokeMethod(methodName,
                {"url": issueParam["url"], "property_name": issueParam["name"], "metadata": issueParam["metadata"], "quantity": issueParam["quantity"]});
        } on PlatformException catch (e) {
            var message = "Failed to execute $methodName: '${e.message}'.";
            print(message);
        }
    }
}