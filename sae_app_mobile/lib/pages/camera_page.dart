import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_page.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _imageFile;
  final CameraService _cameraService = CameraService();

  // Prendre une photo et l'afficher
  Future<void> _takePhoto() async {
    File? photo = await _cameraService.takePhoto();
    if (photo != null) {
      setState(() {
        _imageFile = photo;
      });
    }
  }

  // Sélectionner une image depuis la galerie
  Future<void> _pickImageFromGallery() async {
    File? photo = await _cameraService.pickImageFromGallery();
    if (photo != null) {
      setState(() {
        _imageFile = photo;
      });
    }
  }

  // Envoyer l'image à l'API et afficher les résultats
  Future<void> _uploadPhoto() async {
    if (_imageFile != null) {
      var resultData = await _cameraService.uploadPhoto(
        _imageFile!, 48.289919, 6.941942,
      );
      if (resultData != null) {
        // Navigation vers la page de résultats avec les données récupérées
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
              imageUrl: resultData['imageUrl'],
              name: resultData['name'],
              probability: resultData['probability'],
              latitude: resultData['latitude'],
              longitude: resultData['longitude'],
              similarImages: List<String>.from(resultData['similarImages']),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'envoi de la photo")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucune photo sélectionnée")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prendre une photo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? const Text('Aucune image sélectionnée.')
                : Image.file(_imageFile!, width: 300, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text('Prendre une photo'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text('Sélectionner depuis la galerie'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadPhoto,
              child: const Text('Envoyer la photo'),
            ),
          ],
        ),
      ),
    );
  }
}
