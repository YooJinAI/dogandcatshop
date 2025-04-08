// 상품 상세 페이지
// 선택한 상품의 상세 정보를 보여주고 장바구니에 추가하거나 바로 구매할 수 있는 화면
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/appbar.dart';
import '../widgets/category.dart';
import '../pages/checkout.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;

  const ProductDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  // 상품 이미지를 표시하는 위젯
  Widget _buildProductImage(Product product) => SizedBox(
        width: double.infinity,
        height: 300,
        child: Image.asset(
          product.image,
          fit: BoxFit.cover,
        ),
      );

  // 상품 정보를 표시하는 위젯
  Widget _buildProductInfo(Product product) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상품명과 카테고리, 가격을 표시하는 행
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상품명
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 카테고리 버튼
                      CategoryButton(
                        title: product.category,
                        isSelected: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                // 상품 가격
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
            // 상품 설명 섹션
            const Text(
              '상품 설명',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // 상품 설명 내용
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

  @override
  Widget build(BuildContext context) {
    // ProductProvider를 통해 상품 정보 가져오기
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.getProductById(widget.id);

    // 상품이 없는 경우 메시지 표시
    if (product == null) {
      return const Scaffold(
        appBar: PageAppBar(),
        body: Center(
          child: Text('상품을 찾을 수 없습니다.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PageAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // 상품 이미지와 정보를 스크롤 가능한 영역에 표시
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductImage(product),
                    _buildProductInfo(product),
                  ],
                ),
              ),
            ),
            // 하단 버튼 영역
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 장바구니에 담기 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('장바구니에 추가되었습니다'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('장바구니에 담기'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 바로 구매하기 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        // 장바구니 비우고 현재 상품만 담기
                        cartProvider.clearCart();
                        cartProvider.addItem(product);

                        // 결제 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('구매하기'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
