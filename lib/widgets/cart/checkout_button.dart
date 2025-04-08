import 'package:flutter/material.dart';

class CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const CheckoutButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFFFEE7C5),
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey,
        ),
        child: const Text('결제하기'),
      ),
    );
  }
}
