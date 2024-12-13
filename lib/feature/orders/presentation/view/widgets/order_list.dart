import 'package:flutter/material.dart';
import '../../../domain/entities/order.dart';
import 'order_card.dart';

class OrderList extends StatelessWidget {
  final List<OrderEntity> orders;

  const OrderList({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OrderCard(order: order),
        );
      },
    );
  }
}
