import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/database_service.dart';
import '../widgets/plant_card.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _historique = [];
  List<Map<String, dynamic>> _filteredHistorique = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHistorique();
    _searchController.addListener(_filterHistorique);
  }

  Future<void> _loadHistorique() async {
    DatabaseService dbService = DatabaseService();
    List<Map<String, dynamic>> historique = await dbService.getAllHistorique();

    List<Map<String, dynamic>> modifiableHistorique = List.from(historique);

    modifiableHistorique.sort((a, b) {
      DateTime dateA = DateTime.parse(a['timestamp']);
      DateTime dateB = DateTime.parse(b['timestamp']);
      return dateB.compareTo(dateA);
    });

    setState(() {
      _historique = modifiableHistorique;
      _filteredHistorique = modifiableHistorique;
    });
  }

  void _filterHistorique() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHistorique = _historique
          .where((item) => item['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    // Gestion du mode sombre
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
    Color predictionColor = item['prediction_score'] < 50 ? Colors.redAccent : Colors.green;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['name'],
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: textColor),
              ),
              const SizedBox(height: 10),
              Image.memory(item['image'], fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text(
                'Plante prédite: ${item['name']}',
                style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
              ),
              Text(
                'Confiance de la prédiction: ${item['prediction_score']}%',
                style: TextStyle(color: predictionColor),
              ),
              const SizedBox(height: 5),
              Divider(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                thickness: 2,
              ),
              const SizedBox(height: 5),
              Text(
                'Date de la photo: $formattedDate à $formattedTime',
                style: TextStyle(color: subtitleColor),
              ),
             
              // Button to open the map dialog
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the details dialog
                  _showMapDialog(item['latitude'], item['longitude']);
                },
                child: const Text('Voir sur la carte'),
              ),
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
            ),
          ],
        );
      },
    );
  }

void _showMapDialog(double latitude, double longitude) {
  print("Showing map with coordinates: $latitude, $longitude");
  
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    // CORRECTION ICI: La latitude d'abord, puis la longitude
                    center: LatLng(longitude, latitude),
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'sae_appa',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          // CORRECTION ICI AUSSI: La latitude d'abord, puis la longitude
                          point: LatLng(longitude, latitude),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Position : $latitude, $longitude",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Fermer'),
                ),
              ),
            ],
          ),
        ),
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
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Message si l'historique est vide
          if (_filteredHistorique.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("L'historique est vide.", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          else
            // Liste des résultats filtrés
            Expanded(
              child: ListView.builder(
                itemCount: _filteredHistorique.length,
                itemBuilder: (context, index) {
                  var item = _filteredHistorique[index];
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
            ),
        ],
      ),
    );
  }
}
