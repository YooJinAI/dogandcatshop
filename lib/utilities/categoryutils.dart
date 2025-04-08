import 'package:flutter/material.dart';

class CategoryUtils {
  static const List<String> categories = ['사료', '간식', '옷'];

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case '사료':
        return Icons.pets;
      case '간식':
        return Icons.cookie;
      case '옷':
        return Icons.checkroom;
      default:
        return Icons.pets;
    }
  }
}
