import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/add_product_snackbar.dart';
import 'package:page_transition/page_transition.dart';
import '../../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final responsivePadding = size.width * 0.03;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: DetailsView(product: product),
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 250),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: TColors.primary.withAlpha(10),
          borderRadius: BorderRadius.circular(_getBorderRadius(size)),
          border: Border.all(
            color: Colors.grey.shade500,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(responsivePadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_getBorderRadius(size)),
                  child: Container(
                    decoration:  BoxDecoration(
                     
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl ?? '',
                      fit: BoxFit.contain,
                      errorWidget: (context, error, stackTrace) {
                        return Icon(
                          Icons.error_outline,
                          color: Colors.grey.shade400,
                          size: _getErrorIconSize(size),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(responsivePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: _getTitleFontSize(size),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        if (product.hasDiscount)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: _getHorizontalPadding(size),
                              vertical: _getVerticalPadding(size),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(_getBorderRadius(size) * 0.3),
                              border: Border.all(
                                color: Colors.red.shade200,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              '${product.discountPercentage}%',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: _getDiscountFontSize(size),
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: _getSpacing(size)),
                    if (product.hasDiscount)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${product.discountPrice?.toStringAsFixed(2)} ريال',
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: _getPriceFontSize(size),
                              color: Colors.red.shade700,
                            ),
                          ),
                          SizedBox(width: _getSpacing(size) * 0.5),
                          Text(
                            '${product.price}',
                            style: TextStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: _getOldPriceFontSize(size),
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
                        '${product.price.toStringAsFixed(2)} ريال',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: _getPriceFontSize(size),
                        ),
                      ),
                    SizedBox(height: _getSpacing(size)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (product.isOrganic)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: _getHorizontalPadding(size),
                              vertical: _getVerticalPadding(size),
                            ),
                            decoration: BoxDecoration(
                              color: TColors.primary.withOpacity(.03),
                              borderRadius: BorderRadius.circular(_getBorderRadius(size) * 0.3),
                              border: Border.all(
                                color: TColors.primary..withOpacity(.5),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.eco_outlined,
                                  size: _getIconSize(size),
                                  color: TColors.primary,
                                ),
                                SizedBox(width: _getSpacing(size) * 0.5),
                                Text(
                                  'صحى',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: _getOrganicFontSize(size),
                                    color: TColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        InkWell(
                          onTap: () {
                            try {
                              final cartItem = CartItem(
                                id: product.id!,
                                productId: product.id!,
                                name: product.name,
                                price: product.hasDiscount
                                    ? product.discountPrice!
                                    : product.price,
                                image: product.imageUrl!,
                                quantity: 1,
                              );

                              final cartCubit = context.read<CartCubit>();
                              cartCubit.addItem(cartItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: AddProductSnackbar(product: product),
                                  backgroundColor: TColors.primary,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('حدث خطأ أثناء الإضافة إلى السلة'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.030,
                              vertical: _getVerticalPadding(size),
                            ),
                            decoration: BoxDecoration(
                              color: TColors.primary,
                              borderRadius: BorderRadius.circular(_getBorderRadius(size)),
                            ),
                            child: Icon(
                              Icons.add_shopping_cart_outlined,
                              size: _getIconSize(size),
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

  // Responsive helper methods
  double _getBorderRadius(Size size) => size.width * 0.03;
  double _getSpacing(Size size) => size.height * 0.01;
  double _getHorizontalPadding(Size size) => size.width * 0.015;
  double _getVerticalPadding(Size size) => size.height * 0.004;

  double _getTitleFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size12;
    } else if (size.width < 600) {
      return FontSize.size14;
    }
    return FontSize.size16;
  }

  double _getPriceFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size14;
    } else if (size.width < 600) {
      return FontSize.size16;
    }
    return FontSize.size18;
  }

  double _getOldPriceFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size12;
    } else if (size.width < 600) {
      return FontSize.size14;
    }
    return FontSize.size16;
  }

  double _getDiscountFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size10;
    } else if (size.width < 600) {
      return FontSize.size12;
    }
    return FontSize.size14;
  }

  double _getOrganicFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size10;
    } else if (size.width < 600) {
      return FontSize.size12;
    }
    return FontSize.size14;
  }

  double _getIconSize(Size size) {
    if (size.width < 360) {
      return size.width * 0.04;
    } else if (size.width < 600) {
      return size.width * 0.05;
    }
    return size.width * 0.06;
  }

  double _getErrorIconSize(Size size) {
    if (size.width < 360) {
      return 24;
    } else if (size.width < 600) {
      return 32;
    }
    return 40;
  }
}