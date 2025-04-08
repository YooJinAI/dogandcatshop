// 장바구니 페이지
// 사용자가 선택한 상품들을 보여주고 관리하는 화면
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/appbar.dart';
import '../pages/checkout.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PageAppBar(),
      // Consumer를 사용하여 CartProvider의 상태 변화를 감지
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          // 장바구니가 비어있을 경우 메시지 표시
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text('장바구니가 비어있습니다.'),
            );
          }

          return Column(
            children: [
              // 장바구니 상품 목록
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items.values.toList()[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            // 상품 이미지
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                cartItem.product.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 상품 정보 (이름, 가격)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${cartItem.product.price}원',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 수량 조절 및 삭제 버튼
                            Row(
                              children: [
                                // 수량 감소 버튼
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (cartItem.quantity > 1) {
                                      cartProvider.updateQuantity(
                                        cartItem.product.id,
                                        cartItem.quantity - 1,
                                      );
                                    }
                                  },
                                ),
                                // 현재 수량 표시
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                // 수량 증가 버튼
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    cartProvider.updateQuantity(
                                      cartItem.product.id,
                                      cartItem.quantity + 1,
                                    );
                                  },
                                ),
                                // 상품 삭제 버튼
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    cartProvider
                                        .removeItem(cartItem.product.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 하단 결제 정보 및 결제 버튼
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 총 결제 금액 표시
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '총 결제금액',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cartProvider.totalAmount}원',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // 결제 페이지로 이동하는 버튼
                    ElevatedButton(
                      onPressed: () {
                        if (cartProvider.items.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutPage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('구매하기'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
