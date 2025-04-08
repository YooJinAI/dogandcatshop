import 'dart:io';

class Product {
  final String id;
  final String name;
  final int price;
  final String description;
  final String category;
  final File image;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.createdAt,
  });
}
