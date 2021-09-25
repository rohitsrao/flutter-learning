import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './auth.dart';
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {

  String? _authToken;
  List<Product> _items = [];

  Products(this._authToken, this._items);

  //set authToken(String value) {
  //  _authToken = value;
  //}

  //List<Product> _items = [
  //  Product(
  //    id: 'p1',
  //    title: 'Red Shirt',
  //    description: 'A red shirt - it is pretty red!',
  //    price: 29.99,
  //    imageUrl:
  //        'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //  ),
  //  Product(
  //    id: 'p2',
  //    title: 'Trousers',
  //    description: 'A nice pair of trousers.',
  //    price: 59.99,
  //    imageUrl:
  //        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //  ),
  //  Product(
  //    id: 'p3',
  //    title: 'Yellow Scarf',
  //    description: 'Warm and cozy - exactly what you need for the winter.',
  //    price: 19.99,
  //    imageUrl:
  //        'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //  ),
  //  Product(
  //    id: 'p4',
  //    title: 'A Pan',
  //    description: 'Prepare any meal you want.',
  //    price: 49.99,
  //    imageUrl:
  //        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //  ),
  //];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-update-39d4f-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_authToken'
    );
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          )
        );
      });
      _items = loadedProducts;
      notifyListeners();
    }
    catch (error) {
      throw(error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://flutter-update-39d4f-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }
    catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://flutter-update-39d4f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json'
      );
      await http.patch(
        url,
        body: json.encode({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'imageUrl': updatedProduct.imageUrl,
          'price': updatedProduct.price,
        }),
      );
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://flutter-update-39d4f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json'
    );
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
  }
}

