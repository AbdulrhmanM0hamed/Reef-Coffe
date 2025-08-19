import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    super.deliveryAddress,
    super.phoneNumber,
    String? name,
  }) : super(
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
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.price,
    super.imageUrl,
  });

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
