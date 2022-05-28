import 'package:flutter/material.dart';
import 'package:gametuf/services/authService.dart';
import 'package:provider/provider.dart';

class settingsPage extends StatefulWidget {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("Sign out"),
            onPressed: (){
              myAuth.signout();
            },
          ),
        )
      ),
    );
  }
}
