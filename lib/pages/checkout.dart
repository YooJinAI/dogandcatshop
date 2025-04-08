// 결제 페이지
// 장바구니에 담긴 상품들의 결제를 진행하는 화면
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/checkout/order_summary_list.dart';
import '../widgets/checkout/payment_method_selector.dart';
import '../widgets/checkout/refund_policy.dart';
import '../widgets/checkout/additional_info.dart';
import '../widgets/appbar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _additionalInfoController = TextEditingController();

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PageAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final items = cartProvider.itemsList;
          final total = cartProvider.total;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderSummaryList(items: items),
                const SizedBox(height: 24),
                const PaymentMethodSelector(),
                const SizedBox(height: 24),
                const RefundPolicy(),
                const SizedBox(height: 24),
                AdditionalInfo(controller: _additionalInfoController),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 결제 처리 로직 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('결제가 완료되었습니다.'),
                        ),
                      );
                      cartProvider.clearCart();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFFEE7C5),
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      '${total.toStringAsFixed(0)}원 결제하기',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
