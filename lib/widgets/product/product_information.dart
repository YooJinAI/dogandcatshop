import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../category.dart';

class ProductInformation extends StatelessWidget {
  final Product product;

  const ProductInformation({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CategoryButton(
                      title: product.category,
                      isSelected: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Text(
                '₩${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '상품 설명',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: SingleChildScrollView(
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
