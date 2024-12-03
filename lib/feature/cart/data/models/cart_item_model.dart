class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double getTotal() {
    return price * quantity;
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }
}
