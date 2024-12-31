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
  final String heroTag;

  const ProductImageSection({
    super.key,
    required this.imageUrl,
    required this.productId,
    required this.screenHeight,
    required this.screenWidth,
    required this.isSmallScreen,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.45,
      child: Stack(
        children: [
          Hero(
            tag: heroTag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
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
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.008,
            child: const ArrowBackWidget(),
          ),
        ],
      ),
    );
  }
}
