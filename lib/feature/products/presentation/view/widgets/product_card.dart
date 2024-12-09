import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';
import 'package:page_transition/page_transition.dart';
import '../../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // الحصول على حجم الشاشة
    final isSmallScreen = size.width < 360; // تحديد إذا كان الجهاز صغيرًا
    final double responsivePadding = size.width * 0.03; // حشوة تعتمد على العرض

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: DetailsView(product: product),
            duration: const Duration(milliseconds: 300), // مدة الانتقال
            reverseDuration: const Duration(milliseconds: 250), // مدة العودة
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: TColors.primary.withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade500,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Product Image Section** (Responsive)
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsivePadding),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl ?? '',
                  fit: BoxFit.contain,
                  errorWidget: (context, error, stackTrace) {
                    return Icon(
                      Icons.error_outline,
                      color: Colors.grey.shade400,
                      size: isSmallScreen ? 24 : 32,
                    );
                  },
                ),
              ),
            ),

            // **Product Details Section**
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(responsivePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Discount Tag
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: isSmallScreen
                                  ? FontSize.size10
                                  : FontSize.size14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (product.hasDiscount)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.015, // Dynamic padding
                              vertical: size.height * 0.005,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.red.shade200,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              '${product.discountPercentage}%',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size12,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // **Price Section**
                    if (product.hasDiscount)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${product.discountPrice?.toStringAsFixed(2)} EGP',
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: isSmallScreen
                                  ? FontSize.size12
                                  : FontSize.size16,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                              color: Colors.grey.shade700,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey.shade600,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        '${product.price.toStringAsFixed(2)} EGP',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: isSmallScreen
                              ? FontSize.size12
                              : FontSize.size16,
                        ),
                      ),
                    const SizedBox(height: 8),

                    // **Organic Tag + Add to Cart Button**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Organic or Empty Placeholder
                        if (product.isOrganic)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03,
                              vertical: size.height * 0.004,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.green.shade100,
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.eco_outlined,
                                  size: size.width * 0.04,
                                  color: TColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Organic',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size12,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(), // Empty Placeholder

                        // Add to Cart (Always Fixed)
                        InkWell(
                          onTap: () {
                            // TODO: Add to cart functionality
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03,
                              vertical: size.height * 0.004,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add,
                              size: size.width * 0.05, // Dynamic size
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
