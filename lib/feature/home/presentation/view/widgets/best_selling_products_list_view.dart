import 'package:flutter/material.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/best_selling_product_cart.dart';

class BestSellingProductsListView extends StatelessWidget {
  BestSellingProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sizeHeight * 0.27,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return BestSellingProducts(
                  sizeWidth: sizeWidth, sizeHeight: sizeHeight);
            },
          ),
        ),
      ],
    );
  }
}
