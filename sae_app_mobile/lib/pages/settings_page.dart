import 'package:flutter/material.dart';
import '../main.dart';
import '../services/database_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _confirmDeleteAll() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer l\'historique'),
          content: const Text('Êtes-vous sûr de vouloir supprimer tout l\'historique ? Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
            TextButton(
              child: const Text('Supprimer', style:TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                await DatabaseService().deleteAll();
                // Optionnel : mettre à jour l'interface utilisateur ou afficher un message de confirmation
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres de l'application"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Mode sombre'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (bool value) {
                  MyApp.of(context).toggleTheme(value);
                },
              ),
            ),
            const SizedBox(height: 5),
            Divider(
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              thickness: 2,
            ),
            const SizedBox(height: 5),
            ListTile(
              title: const Text('Vider l\'historique'),
              trailing: FilledButton(
                child: const Text('Tout supprimer'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
                onPressed: _confirmDeleteAll,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
