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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultat de la prédiction"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Image de la plante
            Image.network(imageUrl, width: 300, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),

            // Nom de la plante
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Affichage de la probabilité
            Text("Probabilité: ${(probability * 100).toStringAsFixed(2)}%"),
            const SizedBox(height: 10),

            // Affichage de la latitude et de la longitude
            Text("Latitude: $latitude"),
            Text("Longitude: $longitude"),
            const SizedBox(height: 20),

            // Liste des images similaires
            Text("Images similaires:"),
            const SizedBox(height: 10),
            for (var img in similarImages)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.network(img, width: 100, height: 100, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
    );
  }
}
