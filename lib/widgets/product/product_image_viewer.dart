import 'package:flutter/material.dart';

class ProductImageViewer extends StatelessWidget {
  final String imagePath;

  const ProductImageViewer({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
