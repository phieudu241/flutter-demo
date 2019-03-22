import 'package:flutter/material.dart';

class BitmarksListView extends StatelessWidget {
    final List<dynamic> bitmarks;

    BitmarksListView({Key key, this.bitmarks}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            child: ListView.builder(
                itemCount: bitmarks.length,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (context, position) {
                    return Column(
                        children: <Widget>[
                            Divider(height: 5.0),
                            ListTile(
                                title: Text(
                                    '${bitmarks[position]["id"]}',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.deepOrangeAccent,
                                    ),
                                ),
                                subtitle: Text(
                                    '${bitmarks[position]["issuer"]}',
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.italic,
                                    ),
                                ),
                                leading: Column(
                                    children: <Widget>[
                                        CircleAvatar(
                                            backgroundColor: Colors.blueAccent,
                                            radius: 35.0,
                                            child: Text(
                                                '${bitmarks[position]["status"]}',
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: Colors.white,
                                                ),
                                            ),
                                        )
                                    ],
                                ),
                            ),
                        ],
                    );
                }),
        );
    }
}