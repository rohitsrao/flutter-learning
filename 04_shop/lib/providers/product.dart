import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {

  final String id;
  final String title;
  final String description;
  final double  price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String? token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
    'https://flutter-update-39d4f-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$token'
    );
    try {
      final response = await http.put(
        url,
        body: json.encode({
          id.toString(): isFavorite,
        }),
      );
      print('waiting for put request to complete');
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    }
    catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }

}
