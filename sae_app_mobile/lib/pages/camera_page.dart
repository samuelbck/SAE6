import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';
import 'result_page.dart';
import 'package:geolocator/geolocator.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _imageFile;
  final CameraService _cameraService = CameraService();
  bool _isLoading = false;


  Future<void> _takePhoto() async {
    setState(() {
      _isLoading = true;
    });
    File? photo = await _cameraService.takePhoto();
    if (photo != null) {
      setState(() {
        _imageFile = photo;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la prise de la photo")),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true;
    });
    File? photo = await _cameraService.pickImageFromGallery();
    if (photo != null) {
      setState(() {
        _imageFile = photo;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la sélection de l'image")),
      );
    }
  }
Future<void> _uploadPhoto() async {
  if (_imageFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Aucune photo sélectionnée")),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  // Vérification des permissions de localisation
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission de localisation refusée")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  Position? position;

  try {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  } catch (e) {
    position = await Geolocator.getLastKnownPosition();
  }

  if (position == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Impossible d'obtenir la localisation")),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  // Envoi de la photo avec la localisation
  var resultData = await _cameraService.uploadPhoto(
    _imageFile!, position.longitude, position.latitude,
  );

  setState(() {
    _isLoading = false;
  });

  if (resultData != null) {
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
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prendre une photo')),
      body: Stack(
        children: [
          // Zone principale avec l'image ou l'icône
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isLoading
                    ? const CircularProgressIndicator()
                    : _imageFile == null
                        ? Column(
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 100.0,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 20),
                              const Text('Aucune image sélectionnée.')
                            ],
                          )
                        : Image.file(_imageFile!, width: 300, height: 300, fit: BoxFit.cover),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Alignement des boutons horizontalement en bas
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _takePhoto,
                    icon: const FaIcon(FontAwesomeIcons.camera),
                    iconSize: 40.0,
                    color: Colors.green,
                  ),
                  IconButton(
                    onPressed: _pickImageFromGallery,
                    icon: const FaIcon(FontAwesomeIcons.images),
                    iconSize: 40.0,
                    color:Colors.green,
                  ),
                  IconButton(
                    onPressed: _uploadPhoto,
                    icon: const FaIcon(FontAwesomeIcons.paperPlane),
                    iconSize: 40.0,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
