import 'package:flutter/material.dart';
import '../utilities/categoryutils.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey,
                width: 2,
              ),
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                CategoryUtils.getCategoryIcon(title),
                color: isSelected ? Colors.green : Colors.grey,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.green : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
