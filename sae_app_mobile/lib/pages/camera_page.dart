import 'dart:io'; // Pour Android/iOS
import 'dart:typed_data'; // Pour gérer les bytes de l'image
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Pour kIsWeb

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({Key? key}) : super(key: key);

  @override
  _TakePhotoPageState createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  File? _imageFile;
  Uint8List? _webImage; // Stocke les bytes de l'image sur Web
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La caméra n'est pas supportée sur le Web")),
      );
      return;
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      if (kIsWeb) {
        // Sur Web, convertit l'image en bytes
        final bytes = await photo.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(photo.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prendre une photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null && _webImage == null
                ? const Text('Aucune image sélectionnée.')
                : kIsWeb
                    ? Image.memory(_webImage!, width: 300, height: 300, fit: BoxFit.cover) // Web
                    : Image.file(_imageFile!, width: 300, height: 300, fit: BoxFit.cover), // Mobile
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
          ],
        ),
      ),
    );
  }
}
