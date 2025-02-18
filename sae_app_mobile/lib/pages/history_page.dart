import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> _deleteItem(int id) async {
    DatabaseService dbService = DatabaseService();
    await dbService.deleteHistorique(id);
    _loadHistorique();
  }

  void _showDetailsDialog(Map<String, dynamic> item) {
    DateTime dateTime = DateTime.parse(item['timestamp']);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    Color predictionColor = item['prediction_score'] < 50 ? Colors.redAccent : Colors.green;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(item['image'], fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text('Plante prédite: ${item['name']}', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('Confiance de la prédiction: ${item['prediction_score']}%', style: TextStyle(color: predictionColor)),
              Text('Date de la photo: $formattedDate à $formattedTime'),
              Text('Coordonnées de la photo: ${item['latitude']} ; ${item['longitude']}'),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteItem(item['id']);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fermer'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des scans'),
      ),
      body: ListView.builder(
        itemCount: _historique.length,
        itemBuilder: (context, index) {
          var item = _historique[index];
          return GestureDetector(
            onTap: () => _showDetailsDialog(item),
            child: PlantCard(
              name: item['name'],
              image: item['image'],
              prediction: item['prediction_score'],
              timestamp: item['timestamp'],
            ),
          );
        },
      ),
    );
  }
}