import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<CartCubit>().clearCart();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cartCubit = context.read<CartCubit>();
          final items = cartCubit.items;

          if (items.isEmpty) {
            return const Center(
              child: Text('سلة التسوق فارغة'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return CartItemWidget(
                      item: items[index],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'المجموع',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${cartCubit.total} ج.م',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement checkout
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('إتمام الشراء'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
