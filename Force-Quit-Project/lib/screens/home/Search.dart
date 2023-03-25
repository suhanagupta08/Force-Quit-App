import 'package:flutter/material.dart';
import 'package:quit_force/models/bottomnavigationbar.dart';
import 'package:quit_force/services/auth.dart';
import 'package:quit_force/screens/home/Map.dart';
import 'package:quit_force/screens/body/searchpage.dart';

class Search extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Search'),
          toolbarHeight: 100.0,
          backgroundColor: Colors.green[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: SearchUI(),
      ),
    );
  }
}
