import 'package:flutter/material.dart';
import '../../widgets/category.dart';
import '../../utilities/categoryutils.dart';

class CategoryList extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryTap;

  const CategoryList({
    super.key,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: CategoryUtils.categories.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CategoryButton(
                title: category,
                isSelected: selectedCategory == category,
                onTap: () => onCategoryTap(category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
