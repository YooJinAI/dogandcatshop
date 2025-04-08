import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadSampleProducts() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/products.json');
      final jsonData = json.decode(jsonString);
      final productsList = (jsonData['products'] as List).map((item) {
        return Product(
          id: item['id'],
          name: item['name'],
          price: item['price'].toDouble(),
          description: item['description'],
          category: item['category'],
          image: item['image'],
        );
      }).toList();

      _products = productsList;
      notifyListeners();
    } catch (e) {
      print('샘플 데이터 로드 중 오류 발생: $e');
    }
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
