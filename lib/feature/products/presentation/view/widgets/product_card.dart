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
    final double responsivePadding = size.width * 0.03;

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
          borderRadius: BorderRadius.circular(12),
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
                              horizontal: size.width * 0.015,
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
                            '${product.price}',
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
                          fontSize:
                              isSmallScreen ? FontSize.size12 : FontSize.size16,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                          const SizedBox.shrink(),
                        InkWell(
                          onTap: () {
                            try {
                              print('Debug: Adding product to cart - ${product.name}');
                              print('Debug: Product price - ${product.price}');
                              print('Debug: Product discount price - ${product.discountPrice}');
                              
                              final cartItem = CartItem(
                                id: product.id!,
                                productId: product.id!,
                                name: product.name,
                                price: product.discountPrice == 0.0 ? product.price : product.discountPrice,
                                image: product.imageUrl!,
                                quantity: 1,
                              );

                              print('Debug: CartItem created - ${cartItem.name} - Price: ${cartItem.price}');
                              
                              final cartCubit = context.read<CartCubit>();
                              print('Debug: Got CartCubit instance');
                              
                              cartCubit.addItem(cartItem);
                              print('Debug: Item added to cart');
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: AddProductSnackbar(product: product),
                                  backgroundColor: TColors.primary,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } catch (e) {
                              print('Error adding product to cart: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('حدث خطأ أثناء الإضافة إلى السلة'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
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
                              size: size.width * 0.05,
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
