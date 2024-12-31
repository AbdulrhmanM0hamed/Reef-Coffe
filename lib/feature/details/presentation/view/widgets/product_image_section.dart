import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/arrow_back_widget.dart';

class ProductImageSection extends StatelessWidget {
  final String imageUrl;
  final String productId;
  final double screenHeight;
  final double screenWidth;
  final bool isSmallScreen;

  const ProductImageSection({
    super.key,
    required this.imageUrl,
    required this.productId,
    required this.screenHeight,
    required this.screenWidth,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.45,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 3.2 / 3,
            child: Hero(
              tag: 'product_image_${productId}_list',
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: screenHeight * 0.4,
                width: double.infinity,
                fit: BoxFit.contain,
                errorWidget: (context, error, stackTrace) {
                  return Icon(
                    Icons.error_outline,
                    color: Colors.grey.shade400,
                    size: isSmallScreen ? 48 : 64,
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.04,
            child: const ArrowBackWidget(),
          ),
        ],
      ),
    );
  }
}
