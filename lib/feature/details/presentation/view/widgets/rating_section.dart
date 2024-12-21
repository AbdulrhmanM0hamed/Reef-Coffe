import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/presentation/cubit/rating_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/rating_product_method.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class RatingSection extends StatelessWidget {
  final Product product;
  final double screenWidth;
  final bool isSmallScreen;

  const RatingSection({
    super.key,
    required this.product,
    required this.screenWidth,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: TColors.pound, size: isSmallScreen ? 22 : 26),
        SizedBox(width: screenWidth * 0.015),
        _buildRatingValue(),
        SizedBox(width: screenWidth * 0.02),
        _buildRatingCount(),
        const Spacer(),
        ratingProductMethod(context, isSmallScreen, product),
      ],
    );
  }

  Widget _buildRatingValue() {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        if (state is ProductRatingLoaded) {
          return Text(
            '${state.rating.toStringAsFixed(1)}',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: isSmallScreen ? 16 : 18,
            ),
          );
        }
        return Text(
          '${product.rating}',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: isSmallScreen ? 16 : 18,
          ),
        );
      },
    );
  }

  Widget _buildRatingCount() {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        if (state is ProductRatingLoaded) {
          return Text(
            '( ${state.count} تقييم )',
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: isSmallScreen ? 12 : 14,
              color: TColors.darkGrey,
            ),
          );
        }
        return Text(
          '(${product.ratingCount} تقييم)',
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: isSmallScreen ? 12 : 14,
            color: TColors.darkGrey,
          ),
        );
      },
    );
  }
}
