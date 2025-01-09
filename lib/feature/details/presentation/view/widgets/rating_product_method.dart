 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/feature/details/presentation/controller/rating_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/rating_dialog.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

TextButton ratingProductMethod(BuildContext context, bool isSmallScreen, Product product) {
  void showRatingDialog(BuildContext context) {
    final dialogContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RatingDialog(
        onRatingSubmitted: (rating) {
          Navigator.pop(context);
          dialogContext.read<RatingCubit>().submitOrUpdateRating(
                product.id!,
                rating.toInt(),
              );
        },
      ),
    );
  }

  return TextButton(
    onPressed: () => showRatingDialog(context),
    child: Text(
      'قيم المنتج',
      style: TextStyle(
        fontSize: isSmallScreen ? 16 : 18,
        fontWeight: FontWeight.w800,
        color: TColors.primary,
        decoration: TextDecoration.underline,
      ),
    ),
  );
}
