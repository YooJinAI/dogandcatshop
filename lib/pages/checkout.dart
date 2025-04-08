// 결제 페이지
// 장바구니에 담긴 상품들의 결제를 진행하는 화면
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/appbar.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // CartProvider를 통해 장바구니 상태 관리
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PageAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 주문 상품 목록 섹션
              const Text(
                '주문 상품',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // 장바구니에 있는 모든 상품을 카드 형태로 표시
              ...cartProvider.items.values
                  .map((item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          // 상품 이미지
                          leading: Image.asset(
                            item.product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          // 상품명
                          title: Text(item.product.name),
                          // 수량
                          subtitle: Text('${item.quantity}개'),
                          // 상품 가격 x 수량
                          trailing:
                              Text('${item.product.price * item.quantity}원'),
                        ),
                      ))
                  .toList(),
              // 구분선
              const Divider(height: 32),
              // 총 결제금액 표시
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '총 결제금액',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${cartProvider.totalAmount}원',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // 결제 수단 선택 섹션
              const Text(
                '결제 수단',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // 결제 수단 선택 UI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.credit_card),
                    SizedBox(width: 8),
                    Text('신용카드'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // 환불 정책 섹션
              const Text(
                '환불 정책',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // 환불 정책 내용
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '상품 수령 후 7일 이내에 환불이 가능합니다.\n미개봉 상품에 한해 전액 환불됩니다.',
                  style: TextStyle(height: 1.5),
                ),
              ),
              const SizedBox(height: 32),
              // 추가 정보 섹션
              const Text(
                '추가 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // 배송 시 참고사항 입력 필드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '배송 시 참고사항을 입력해주세요.',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // 결제하기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 결제 처리 로직
                    cartProvider.clearCart();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('결제가 완료되었습니다.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('결제하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
