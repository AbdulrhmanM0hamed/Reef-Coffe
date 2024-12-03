import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/utils/local_storage/categories_list.dart';

class CategoryCart extends StatelessWidget {
  const CategoryCart({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: categories[index]['color'],
        border: Border.all(color: categories[index]['borderColor'], width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            categories[index]['image']!,
            width: 80,
            height: 60,
          ),
          const SizedBox(height: 8),
          Text(
            categories[index]['title']!,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
            ),
          ),
        ],
      ),
    );
  }
}
