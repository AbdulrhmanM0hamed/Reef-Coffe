import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/pages/cart_page.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class AddProductSnackbar extends StatelessWidget {
  const AddProductSnackbar({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'تم اضافة ',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
            ),
          ),
          TextSpan(
            text: product.name,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              
              fontSize: FontSize.size14,
            ),
          ),
          TextSpan(
            text: ' الى السلة',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
            ),
          ),
        ],
      ),
    );
  }
}