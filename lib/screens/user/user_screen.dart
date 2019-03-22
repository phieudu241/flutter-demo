import 'package:bitmark_health/components/bitmark_list_view.dart';
import 'package:bitmark_health/screens/base_screen.dart';
import 'package:bitmark_health/services/bitmark_API.dart';
import 'package:bitmark_health/services/bitmark_SDK.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserScreen extends StatefulWidget with BaseScreen {
    UserScreen({BuildContext context}) {
        this.context = context;
        this.appState = this.getAppState(context);
    }

    @override
    UserScreenState createState() => new UserScreenState();
}

class UserScreenState extends State<UserScreen> {
    var bitmarks;

    @override
    void initState() {
        super.initState();
        loadPageData();
    }

    loadPageData() {
        getBitmarks();
    }

    getBitmarks() async {
        var results = await BitmarkAPI.get100Bitmarks(widget.appState.user.bitmarkAccountNumber);
        print(results);
        setState(() {
            bitmarks = results["bitmarks"];
        });
    }

    Future selectImageThenIssue() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        print(image);
        await issue(image.path);
    }

    issue(filePath) async {
        var issueParam = {
            "url": filePath,
            "name": "HR${DateFormat("yyyyMMMDDHHmmss").format(DateTime.now())}",
            "metadata": {
                "Type": "Health",
                "Source": "Medical Records",
                "Collection Date": DateFormat("yyyyMMMDDHHmmss").format(DateTime.now())
            },
            "quantity": 1
        };

        var results = await BitmarkSDK.issue(issueParam);
        print(results);
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text('User Bitmarks'),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.settings),
                        tooltip: 'Settings',
                        onPressed: () {
                            Navigator.pushNamed(context, "/mock");
                        },
                    ),
                ],
            ),
            body: bitmarks != null
                ? BitmarksListView(bitmarks: bitmarks) // return the ListView widget
                : Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
                onPressed: () {selectImageThenIssue();},
                child: Icon(Icons.add,),
                foregroundColor: Colors.white,
            ),
        );
    }
}
