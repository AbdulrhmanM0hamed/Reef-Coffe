import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class SupplementProductCard extends StatelessWidget {
  final Product product;

  const SupplementProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    final List<Color> colors = [
      Colors.brown[200]!,
      Colors.lightGreen[200]!,
      Colors.blue[200]!,
      Colors.blueGrey[300]!,
      Colors.deepPurple[200]!,
      Colors.cyan[300]!,
      Colors.deepOrange[200]!,
      Colors.red[200]!,
      Colors.teal[200]!,
    ];

    final randomColor = colors[Random().nextInt(colors.length)];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsView(product: product),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = size.width * (isSmallScreen ? 0.85 : 0.75);
          final imageSize = cardWidth * 0.2;
          final buttonWidth = cardWidth * 0.28;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: cardWidth,
                height: size.height * 0.22,
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: randomColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: imageSize,
                      height: imageSize * 1.9,
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.name,
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: isSmallScreen ? FontSize.size16 : FontSize.size18,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (product.hasDiscount && product.discountPrice != null) ...[
                                      Text(
                                        '${product.discountPrice} ريال',
                                        style: getBoldStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: isSmallScreen ? FontSize.size14 : FontSize.size16,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                     
                                    ] else
                                      Text(
                                        '${product.price} ريال',
                                        style: getBoldStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: isSmallScreen ? FontSize.size14 : FontSize.size16,
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 27,
                                width: buttonWidth,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () => _addToCart(context),
                                  child: const Text(
                                    'اضف للسلة',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: FontConstant.cairo,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (product.hasDiscount && product.discountPrice != null)
                Positioned(
                  top: -8,
                  left: 17,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${product.price}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                        const Text(
                          ' ريال',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final newItem = CartItem(
      id: product.id!,
      productId: product.id!,
      name: product.name,
      price: product.hasDiscount ? product.discountPrice! : product.price,
      image: product.imageUrl ?? '',
      quantity: 1,
    );

    context.read<CartCubit>().addItem(newItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إضافة ${product.name} إلى السلة',
          style: getSemiBoldStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}