import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/custom_text_form_field.dart';
import 'package:hyper_market/core/utils/local_storage/categories_list.dart';
import 'package:hyper_market/feature/categories/presentation/view/widgets/category_cart.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_text_field.dart';

class CategoriesViewBodyApp extends StatelessWidget {
  const CategoriesViewBodyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          const CustomSearchTextField(),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryCart(
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
