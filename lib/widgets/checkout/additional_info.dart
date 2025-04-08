import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final TextEditingController controller;

  const AdditionalInfo({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추가 정보',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '배송 시 참고사항을 입력해주세요.',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
