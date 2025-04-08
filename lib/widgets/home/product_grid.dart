import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'product_grid_item.dart';
import '../../pages/productdetail.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(String) onDeleteProduct;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onDeleteProduct,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text('등록된 상품이 없습니다.'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductGridItem(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  id: product.id,
                ),
              ),
            );
          },
          onDelete: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('상품 삭제'),
                content: const Text('이 상품을 삭제하시겠습니까?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      onDeleteProduct(product.id);
                      Navigator.of(context).pop();
                    },
                    child: const Text('삭제'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
