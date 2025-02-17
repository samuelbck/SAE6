import 'package:flutter/material.dart';
import '../database_helper.dart';

class TakePhotoPage extends StatefulWidget {
  @override
  _TakePhotoPageState createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  // Exemple de fonction pour ajouter un élément à la base de données
  Future<void> _insertItem() async {
    Map<String, dynamic> newItem = {
      'name': 'New Item',
      'value': 42,
    };
    await DatabaseHelper().insert(newItem);
    print('Item inséré dans la base');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _insertItem,
            child: Text('Ajouter un élément'),
          ),
          // D'autres widgets de la page de la caméra ici...
        ],
      ),
    );
  }
}
