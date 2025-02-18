import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../widgets/plant_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _historique = [];

  @override
  void initState() {
    super.initState();
    _loadHistorique();
  }

  Future<void> _loadHistorique() async {
    DatabaseService dbService = DatabaseService();
    List<Map<String, dynamic>> historique = await dbService.getAllHistorique();
    setState(() {
      _historique = historique;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Plantes'),
      ),
      body: ListView.builder(
        itemCount: _historique.length,
        itemBuilder: (context, index) {
          var item = _historique[index];
          return PlantCard(
            name: item['name'],
            image: item['image'],
            prediction: item['prediction_score'],
            timestamp: item['timestamp'],
          );
        },
      ),
    );
  }
}
