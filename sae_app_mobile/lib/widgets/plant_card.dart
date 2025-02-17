// Widget d'une carte de plante (pour l'historique)
import 'dart:typed_data';
import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String name;
  final Uint8List image;
  final String timestamp;

  const PlantCard({
    Key? key,
    required this.name,
    required this.image,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.memory(image),
        title: Text(name),
        subtitle: Text('Date: $timestamp'),
      ),
    );
  }
}
