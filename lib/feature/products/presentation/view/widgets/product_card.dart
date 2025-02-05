import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/add_product_snackbar.dart';
import '../../../domain/entities/product.dart';
import 'dart:math';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final responsivePadding = size.width * 0.03;
    final random = Random().nextInt(10000);
    final heroTag = 'product_${product.id}_$random';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds:550),
            reverseTransitionDuration: const Duration(milliseconds: 550),
            pageBuilder: (context, animation, secondaryAnimation) => DetailsView(
              product: product,
              heroTag: heroTag,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
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
              flex: 5,
              child: Hero(
                tag: heroTag,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_getBorderRadius(size)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl ?? '',
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>  const Center(
                              child: CircularProgressIndicator(
                                color: TColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
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
                    );
                  },
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
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
                              style: getSemiBoldStyle(
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
                   SizedBox(height: _getSpacing(size) * 0.9),

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
                           SizedBox(
                            height: 2,
                          ),
                        _buildAddToCartButton(context),
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

  Widget _buildAddToCartButton(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoggedIn = !Prefs.getBool(KIsGuestUser) && Prefs.getBool(KIsloginSuccess) == true;
    
    return InkWell(
      onTap: isLoggedIn 
        ? () {
            final cartItem = CartItem(
              id: product.id!,
              productId: product.id!,
              name: product.name,
              price: product.hasDiscount ? product.discountPrice! : product.price,
              image: product.imageUrl ?? '',
              quantity: 1,
            );
            context.read<CartCubit>().addItem(cartItem);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AddProductSnackbar(product: product),
                backgroundColor: TColors.primary,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        : () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يجب تسجيل الدخول لإضافة المنتج للسلة'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pushNamed(context, SigninView.routeName);
          },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.030,
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
    );
  }

  // Responsive helper methods
  double _getBorderRadius(Size size) {
    final width = size.width;
    if (width >= 1024) {
      return 12;
    } else if (width >= 768) {
      return 10;
    } else {
      return 8;
    }
  }

  double _getSpacing(Size size) {
    final width = size.width;
    if (width >= 1024) {
      return 8;
    } else if (width >= 768) {
      return 7;
    } else if (width >= 390) {
      return 4;
    } else {
      return 4;
    }
  }

  double _getHorizontalPadding(Size size) {
    final width = size.width;
    if (width >= 1024) {
      return width * 0.010;
    } else if (width >= 768) {
      return width * 0.015;
    } else if (width >= 480) {
      return width * 0.020;
    } else {
      return width * 0.025;
    }
  }

  double _getVerticalPadding(Size size) {
    final width = size.width;
    if (width >= 1024) {
      return 9;
    } else if (width >= 768) {
      return 5;
    } else if (width >= 390) {
      return 3;
    } else {
      return 2;
    }
  }

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
    final width = size.width;
    if (width >= 1024) {
      return width * 0.014;
    } else if (width >= 768) {
      return width * 0.018;
    } else if (width >= 480) {
      return width * 0.035;
    } else {
      return width * 0.04;
    }
  }

  double _getOrganicFontSize(Size size) {
    final width = size.width;
    if (width >= 1024) {
      return 16;
    } else if (width >= 768) {
      return 14;
    } else if (width >= 390) {
      return 12;
    } else {
      return 10;
    }
  }

  double _getIconSize(Size size) {
    final width = size.width;
    if (width >= 1024) { 
      return 24;
    } else if (width >= 768) { 
      return 22;
    } else if (width >= 390) { 
      return 20;
    } else { 
      return 18;
    }
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