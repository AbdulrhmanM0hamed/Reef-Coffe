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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Price
                  Text(
                    '${item.price!.toStringAsFixed(2)} EGP',
                    style: TextStyle(
                      fontSize: 14,
                      color: TColors.primary,
                      fontWeight: FontWeight.w600,
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
