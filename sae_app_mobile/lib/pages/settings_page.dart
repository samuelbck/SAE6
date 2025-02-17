import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.settings, size: 100),
          SizedBox(height: 20),
          Text('Page des Paramètres', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
