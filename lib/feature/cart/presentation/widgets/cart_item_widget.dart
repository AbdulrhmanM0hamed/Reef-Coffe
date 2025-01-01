import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/widgets/add_and_del.dart';
import '../../data/models/cart_item_model.dart';
import '../cubit/cart_cubit.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  double _getResponsiveSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return baseSize * 1.3;
    } else if (width >= 768) {
      return baseSize * 1.2;
    } else if (width >= 390) {
      return baseSize;
    } else {
      return baseSize * 0.8;
    }
  }

  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return baseSize * 1.2;
    } else if (width >= 768) {
      return baseSize * 1.1;
    } else if (width >= 390) {
      return baseSize;
    } else {
      return baseSize * 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white60,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  width: _getResponsiveSize(context, 100),
                  height: _getResponsiveSize(context, 100),
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: _getResponsiveSize(context, 32),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Price
                  Text(
                    '${item.price!.toStringAsFixed(2)} ريال',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 14),
                      color: TColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      AddAndDeleteItem(
                        number: item.quantity,
                        onPressedAdd: () {
                          context.read<CartCubit>().updateQuantity(
                                item.productId,
                                item.quantity + 1,
                              );
                        },
                        onPressedDel: () {
                          if (item.quantity > 1) {
                            context.read<CartCubit>().updateQuantity(
                                  item.productId,
                                  item.quantity - 1,
                                );
                          }
                        },
                        sizeWidth: size,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          context.read<CartCubit>().removeItem(item.productId);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
