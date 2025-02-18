import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlantCard extends StatelessWidget {
  final String name;
  final Uint8List image;
  final String timestamp;
  final double prediction;

  const PlantCard({
    Key? key,
    required this.name,
    required this.image,
    required this.timestamp,
    required this.prediction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    // Gestion du mode sombre
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
    Color predictionColor = prediction < 50 ? Colors.redAccent : Colors.green;

    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: cardColor,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  image,
                  fit: BoxFit.cover,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$prediction% de confiance',
                    style: TextStyle(
                      fontSize: 14,
                      color: predictionColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$formattedDate à $formattedTime',
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
