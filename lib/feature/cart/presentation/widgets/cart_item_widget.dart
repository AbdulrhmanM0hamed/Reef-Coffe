import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

   var size = MediaQuery.of(context).size.width;


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.image,
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price} ج.م',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            AddAndDeleteItem(
              number: item.quantity,
              onPressedAdd: (){
                context.read<CartCubit>().updateQuantity(
                          item.productId,
                          item.quantity + 1,
                         );
              },
              onPressedDel: (){
                  if (item.quantity > 1) {
                       context.read<CartCubit>().updateQuantity(
                            item.productId,
                            item.quantity - 1,
                          );}
              },
              sizeWidth: size ,
            ),
             IconButton(
               icon: const Icon(
                 Icons.delete_outline,
                 color: Colors.grey,
               ),
               onPressed: () {
                 context.read<CartCubit>().removeItem(item.productId);
               },
             ),

 
          ],
        ),
      ),
    );
  }
}
