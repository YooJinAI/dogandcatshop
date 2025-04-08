// 장바구니 페이지
// 사용자가 선택한 상품들을 보여주고 관리하는 화면
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/appbar.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/cart_summary.dart';
import '../widgets/cart/checkout_button.dart';
import '../pages/checkout.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PageAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text('장바구니가 비어있습니다.'),
            );
          }

          return Column(
            children: [
              // 장바구니 아이템 목록
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items.values.elementAt(index);
                    return CartItemCard(
                      item: item,
                      onDelete: () {
                        cartProvider.removeItem(item.product.id);
                      },
                      onUpdateQuantity: (quantity) {
                        cartProvider.updateQuantity(item.product.id, quantity);
                      },
                    );
                  },
                ),
              ),
              // 구분선
              const Divider(height: 1),
              // 하단 영역 (총 금액 + 결제 버튼)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CartSummary(totalAmount: cartProvider.total),
                    const SizedBox(height: 16),
                    CheckoutButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutPage(),
                          ),
                        );
                      },
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
