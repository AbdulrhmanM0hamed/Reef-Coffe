import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required String id,
    required String userId,
    required List<OrderItem> items,
    required double totalAmount,
    required String status,
    required DateTime createdAt,
    String? deliveryAddress,
    String? phoneNumber,
    String? name,
  }) : super(
          id: id,
          userId: userId,
          items: items,
          totalAmount: totalAmount,
          status: status,
          createdAt: createdAt,
          deliveryAddress: deliveryAddress,
          phoneNumber: phoneNumber,
          name: name ?? '',
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        id: json['id'] ?? '',
        userId: json['user_id'] ?? '',
        items: (json['items'] as List?)
                ?.map((item) => OrderItemModel.fromJson(item))
                .toList() ??
            [],
        totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
        status: json['status'] ?? 'pending',
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        deliveryAddress: json['delivery_address'],
        phoneNumber: json['phone_number'],
        name: json['name'] ?? '',
      );
    } catch (e) {
      print('Error parsing OrderModel: $e');
      rethrow;
    }
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
      'name': name,
    };
  }
}

class OrderItemModel extends OrderItem {
  OrderItemModel({
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
    try {
      return OrderItemModel(
        productId: json['product_id'] ?? '',
        productName: json['product_name'] ?? '',
        quantity: json['quantity'] ?? 0,
        price: (json['price'] ?? 0.0).toDouble(),
        imageUrl: json['image_url'],
      );
    } catch (e) {
      print('Error parsing OrderItemModel: $e');
      rethrow;
    }
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
