import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);  // Ajout de 'const'
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text(
        'Page des paramètres',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
