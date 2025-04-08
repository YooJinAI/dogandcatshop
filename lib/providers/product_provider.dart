import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Product? findById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (error) {
      return null;
    }
  }
}
