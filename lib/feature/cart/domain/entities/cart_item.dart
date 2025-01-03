import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
