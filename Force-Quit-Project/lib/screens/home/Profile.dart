import 'package:flutter/material.dart';
import 'package:quit_force/models/bottomnavigationbar.dart';
import 'package:quit_force/services/auth.dart';
import 'package:quit_force/screens/body/profilebody.dart';

class Profile extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Profile'),
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
        body: SettingsUI(),
      ),
    );
  }
}
