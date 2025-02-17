// Modele des données de la plante
import 'dart:typed_data';

class Plant {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final double predictionScore;
  final Uint8List image;
  final String url;
  final DateTime timestamp;

  Plant({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.predictionScore,
    required this.image,
    required this.url,
    required this.timestamp,
  });

  // Convertion pour l'insertion dans la base
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'predictionScore': predictionScore,
      'image': image,
      'url': url,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Créer un objet Plant depuis la base de données
  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      predictionScore: map['predictionScore'],
      image: Uint8List.fromList(map['image']),
      url: map['url'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}