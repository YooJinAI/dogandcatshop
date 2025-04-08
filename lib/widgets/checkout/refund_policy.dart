import 'package:flutter/material.dart';

class RefundPolicy extends StatelessWidget {
  const RefundPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '환불 정책',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '구매하신 상품의 환불은 구매일로부터 7일 이내에 가능합니다. '
            '상품이 개봉되지 않은 상태여야 하며, 배송비는 구매자 부담입니다.',
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
