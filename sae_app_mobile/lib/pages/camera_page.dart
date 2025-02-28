/// The `Camera` class in Dart is a StatefulWidget that allows users to take photos, select images from
/// the gallery, and upload photos with location data for processing.
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
    setState(() => _isLoading = true);
    File? photo = await _cameraService.takePhoto();
    setState(() {
      _imageFile = photo;
      _isLoading = false;
    });
    if (photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la prise de la photo")),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    setState(() => _isLoading = true);
    File? photo = await _cameraService.pickImageFromGallery();
    setState(() {
      _imageFile = photo;
      _isLoading = false;
    });
    if (photo == null) {
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
    
    setState(() => _isLoading = true);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission de localisation refusée")),
        );
        return;
      }
    }

    Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .catchError((_) => Geolocator.getLastKnownPosition());
    if (position == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'obtenir la localisation")),
      );
      return;
    }

    var resultData = await _cameraService.uploadPhoto(
      _imageFile!, position.longitude, position.latitude,
    );

    setState(() => _isLoading = false);
    if (resultData != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ResultPage(
            imageUrl: resultData['imageUrl'],
            name: resultData['name'],
            probability: resultData['probability'],
            latitude: resultData['latitude'],
            longitude: resultData['longitude'],
            similarImages: List<String>.from(resultData['similarImages']),
          ),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut))
                  .animate(animation),
              child: child,
            );
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isLoading
                    ? const CircularProgressIndicator()
                    : _imageFile == null
                        ? Column(
                            children: const [
                              Icon(Icons.camera_alt, size: 100.0, color: Colors.grey),
                              SizedBox(height: 20),
                              Text('Aucune image sélectionnée.')
                            ],
                          )
                        : Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green, width: 5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            ),
                          ),
                const SizedBox(height: 20),
              ],
            ),
          ),
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
                    color: Colors.green,
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
