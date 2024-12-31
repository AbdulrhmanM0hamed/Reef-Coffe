import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/product_detials_gridview.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isTablet = MediaQuery.of(context).size.width >= 768;
        
        return SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'معلومات المنتج',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: isTablet ? 20 : 18,
                  color: TColors.darkGrey,
                ),
              ),
              
              ProductDetialsGridView(
                product: product,
              ),
            ],
          ),
        );
      },
    );
  }
}
