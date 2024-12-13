import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String id,
    required String userId,
    required List<OrderItem> items,
    required double totalAmount,
    required String status,
    required DateTime createdAt,
    String? deliveryAddress,
    String? phoneNumber,
  }) : super(
          id: id,
          userId: userId,
          items: items,
          totalAmount: totalAmount,
          status: status,
          createdAt: createdAt,
          deliveryAddress: deliveryAddress,
          phoneNumber: phoneNumber,
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      totalAmount: json['total_amount'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      deliveryAddress: json['delivery_address'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'delivery_address': deliveryAddress,
      'phone_number': phoneNumber,
    };
  }
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required String productId,
    required String productName,
    required int quantity,
    required double price,
    String? imageUrl,
  }) : super(
          productId: productId,
          productName: productName,
          quantity: quantity,
          price: price,
          imageUrl: imageUrl,
        );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'image_url': imageUrl,
    };
  }
}
