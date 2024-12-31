import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class ProductDetialsGridView extends StatelessWidget {
  const ProductDetialsGridView({
    super.key,
    required this.product,
  });

  final Product product;

  Widget buildInfoCard({
    required String mainText,
    required String subText,
    String? extraText,
    required Widget iconInfo,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isTablet = MediaQuery.of(context).size.width >= 768;
        
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : const Color.fromARGB(255, 230, 229, 229),
            borderRadius: BorderRadius.circular(12),
            
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconInfo,
              const SizedBox(height: 8),
              Text(
                mainText,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: isTablet ? 16 : 14,
                  color: TColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              if (extraText != null) ...[
                const SizedBox(height: 4),
                Text(
                  extraText,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: isTablet ? 14 : 12,
                    color: TColors.darkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (subText.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subText,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: isTablet ? 14 : 12,
                    color: TColors.darkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final iconSize = isTablet ? 45.0 : 40.0;

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.35,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: isTablet ? 1.3 : 1.4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
     
        children: [
              buildInfoCard(
            mainText: '${product.caloriesPer100g}',
            subText: ' ',
            extraText: 'سعرة حرارية',
            iconInfo: SvgPicture.asset(
              'assets/images/calory.svg',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
          buildInfoCard(
            mainText: product.expiryName,
            subText: 'وقت التحضير',
            iconInfo: SvgPicture.asset(
              'assets/images/cooking-time.svg',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
          buildInfoCard(
            mainText: '${product.weight}',
            subText: '',
            extraText: 'جرام',
            iconInfo: SvgPicture.asset(
              'assets/images/weight.svg',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
      
          buildInfoCard(
            mainText: product.isOrganic ? 'صحى' : 'غير صحى',
            subText: product.isOrganic ? '100% صحى' : 'غير صحى',
            iconInfo: SvgPicture.asset(
              'assets/images/lotus.svg',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}