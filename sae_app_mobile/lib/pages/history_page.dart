import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);  // Ajout de 'const'
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text(
        'Page de l\'historique',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
