import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/info_section.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ProductDetialsGridView extends StatelessWidget {
  const ProductDetialsGridView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.product,
    required this.isSmallScreen,
  });

  final double screenHeight;
  final double screenWidth;
  final Product product;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: screenHeight * 0.01,
      crossAxisSpacing: screenWidth * 0.02,
      childAspectRatio: screenWidth / (screenHeight * 0.31),
      children: [
        buildInfoCard(
          mainText: '${product.caloriesPer100g}',
          subText: 'سعرة حرارية',
          extraText: 'لكل وجبة',
          iconInfo: SvgPicture.asset(
            'assets/images/calory.svg',
            width: isSmallScreen ? 40 : 45,
            height: isSmallScreen ? 40 : 45,
          ),
        ),
        buildInfoCard(
          mainText: product.isOrganic
              ? 'صحى'
              : 'غير صحى',
          subText: product.isOrganic
              ? '100% صحى'
              : 'غير صحى',
          iconInfo: SvgPicture.asset(
            'assets/images/lotus.svg',
            width: isSmallScreen ? 40 : 45,
            height: isSmallScreen ? 40 : 45,
          ),
        ),
        buildInfoCard(
          mainText: product.expiryName,
          subText: 'وقت التحضير',
          iconInfo: SvgPicture.asset(
            'assets/images/cooking-time.svg',
            width: isSmallScreen ? 40 : 45,
            height: isSmallScreen ? 40 : 45,
          ),
        ),
        buildInfoCard(
          mainText: '${10}',
          subText: 'جرام',
          extraText: 'وزن الوجبة',
          iconInfo: SvgPicture.asset(
            'assets/images/weight.svg',
            width: isSmallScreen ? 40 : 45,
            height: isSmallScreen ? 40 : 45,
          ),
        ),
      ],
    );
  }
}