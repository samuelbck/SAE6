import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double probability;
  final double latitude;
  final double longitude;
  final List<String> similarImages;

  ResultPage({
    required this.imageUrl,
    required this.name,
    required this.probability,
    required this.latitude,
    required this.longitude,
    required this.similarImages,
  });

  @override
  Widget build(BuildContext context) {
    // Gestion du mode sombre
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultat de la prédiction"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Image de la plante avec carte
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: cardColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Transform.rotate(
                  angle: 90 * 3.1415927 / 180, // Rotation de 90 degrés dans le sens des aiguilles d'une montre
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Nom de la plante avec style
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Probabilité: ${(probability * 100).toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Latitude: $latitude",
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                    ),
                    Text(
                      "Longitude: $longitude",
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Liste des images similaires
            Text(
              "Images similaires:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),

                Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var img in similarImages)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent, // Pour fond transparent
                              child: Stack(
                                children: [
                                  // Image agrandie
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      img,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      height: MediaQuery.of(context).size.height * 0.7,
                                      fit: BoxFit.contain, // Pour voir toute l’image sans déformation
                                    ),
                                  ),
                                  
                                  // Bouton de fermeture
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: Icon(Icons.close, color: Colors.white, size: 30),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          img,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
