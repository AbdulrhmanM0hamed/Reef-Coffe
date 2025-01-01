import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/product_detials_gridview.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  double _getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return 20;
    } else if (width >= 768) {
      return 18;
    } else if (width >= 390) {
      return 16;
    } else {
      return 14;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات المنتج',
            style: getBoldStyle(
               fontFamily: FontConstant.cairo,
              fontSize: _getTitleFontSize(context),
              color: TColors.darkGrey,
            ),
          ),
          ProductDetialsGridView(
            product: product,
          ),
        ],
      ),
    );
  }
}
