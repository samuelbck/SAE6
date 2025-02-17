import 'package:flutter/material.dart';
import 'pages/camera_page.dart';
import 'pages/settings_page.dart';
import 'pages/history_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
void main() async {
  try {
    runApp(MyApp());
  } catch (e) {
    print("Erreur lors de l'initialisation: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // La page d'accueil
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  // Liste des pages de l'application (sans 'const')
  static List<Widget> _pages = <Widget>[
    HistoryPage(),
    Camera(),  
    SettingsPage(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Bottom'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètre',
          ),
        ],
      ),
    );
  }
}
