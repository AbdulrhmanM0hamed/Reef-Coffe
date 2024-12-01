import 'package:flutter/material.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';

import 'package:hyper_market/feature/home/presentation/view/widgets/exclusive_product_cart.dart';

class ExclusiveOfferSection extends StatelessWidget {
  ExclusiveOfferSection({Key? key}) : super(key: key);

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
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DetailsView.routeName);
                  },
                  child: ExclusiveProductCart(
                      sizeWidth: sizeWidth, sizeHeight: sizeHeight));
            },
          ),
        ),
      ],
    );
  }
}
