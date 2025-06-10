import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback? onSelected;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(category.name),
      selected: isSelected,
      onSelected: (_) => onSelected?.call(),
      selectedColor: Colors.blueAccent,
      backgroundColor: Colors.grey[300],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}