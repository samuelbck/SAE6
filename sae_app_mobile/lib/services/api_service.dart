import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/database_service.dart';
import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();
  final String apiUrl = "https://plant.id/api/v3/identification"; 
  final String apiKey = "QMHLctcWYAUYC8MIDQTJEauRhuUQoEABoBaxvLhtfPGXD1VSOA"; 

  // Prendre une photo avec la caméra
  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }

  // Sélectionner une image depuis la galerie
  Future<File?> pickImageFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    return photo != null ? File(photo.path) : null;
  }


  Future<String> encodeImageToBase64(File image) async {
    List<int> imageBytes = await image.readAsBytes();
    return base64Encode(imageBytes);
  }

  //API Plant.io
  Future<Map<String, dynamic>?> uploadPhoto(File photo, double latitude, double longitude) async {
    try {
      String base64Image = await encodeImageToBase64(photo);

      // Créer les données JSON
      var requestBody = jsonEncode({
        "images": [base64Image],
        "latitude": latitude,
        "longitude": longitude,
        "similar_images": true,
      });

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Api-Key": apiKey,  // Utilisation de la clé API
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);

        var resultData = {
          "imageUrl": responseData['input']['images'][0],
          "name": responseData['result']['classification']['suggestions'][0]['name'],
          "probability": double.parse((responseData['result']['classification']['suggestions'][0]['probability'] * 100).toStringAsFixed(1)),
          "latitude": latitude,
          "longitude": longitude,
          "similarImages": List<String>.from(responseData['result']['classification']['suggestions'][0]['similar_images'].map((image) => image['url'])),
        };

      DatabaseService dbService = DatabaseService();

      final Uint8List imageBytes = await photo.readAsBytes();

      await dbService.insert(
        'historique',
        {
          'name': resultData['name'],
          'latitude': latitude,
          'longitude': longitude,
          // un seul chiffre apres la virgule
          'prediction_score': resultData['probability'],
          'image': imageBytes,
          'url': resultData['imageUrl'],
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

        return resultData;
      } else {
        print("Erreur lors de l'envoi : ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Exception lors de l'envoi de la photo : $e");
      return null;
    }
  }
}
