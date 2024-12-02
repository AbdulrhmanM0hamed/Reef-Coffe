import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/custom_text_form_field.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_text_field.dart';

class CategoriesViewBody extends StatelessWidget {
  const CategoriesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          CustomSearchTextField(),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: categories[index]['color'],
                    border: Border.all(
                        color: categories[index]['borderColor'],
                        width: 1), // ضبط لون الحدود
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> categories = [
  {
    'title': ' الخضروات والفواكه',
    'color': Colors.greenAccent.withOpacity(0.15),
    'borderColor': Colors.greenAccent.withOpacity(0.25),
    'image': 'assets/images/1.png',
  },
  {
    'title': 'المخبوزات والحلويات',
    'color': Colors.amberAccent.withOpacity(0.15),
    'borderColor': Colors.amberAccent.withOpacity(0.25),
    'image': 'assets/images/2.png',
  },
  {
    'title': 'اللحوم والاسماك',
    'color': Colors.redAccent.withOpacity(0.15),
    'borderColor': Colors.redAccent.withOpacity(0.25),
    'image': 'assets/images/3.png',
  },
  {
    'title': 'المقرمشات',
    'color': Colors.brown.withOpacity(0.15),
    'borderColor': Colors.brown.withOpacity(0.25),
    'image': 'assets/images/4.png',
  },
  {
    'title': 'الالبان والبيض',
    'color': Colors.blueAccent.withOpacity(0.15),
    'borderColor': Colors.blueAccent.withOpacity(0.25),
    'image': 'assets/images/5.png',
  },
];
