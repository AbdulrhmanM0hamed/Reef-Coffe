import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/local_storage/items_of_detials_view.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/nutritions_cart.dart';

class InfoSection extends StatelessWidget {
  InfoSection();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2, // نسبة العرض إلى الارتفاع
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return NutritionsCart(item: item, size: size);
        },
      ),
    );
  }
}
