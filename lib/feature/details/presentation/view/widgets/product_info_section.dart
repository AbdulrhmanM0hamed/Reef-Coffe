import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/product_detials_gridview.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;
  final bool isSmallScreen;
  final double screenHeight;
  final double screenWidth;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.isSmallScreen,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات المنتج',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: isSmallScreen ? 18 : 20,
            color: TColors.darkGrey,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        ProductDetialsGridView(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          product: product,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }
}
