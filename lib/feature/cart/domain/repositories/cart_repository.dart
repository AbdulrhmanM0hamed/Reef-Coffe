import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, CartItem>> addToCart(CartItem item);
  Future<Either<Failure, CartItem>> updateQuantity(String productId, int quantity);
  Future<Either<Failure, void>> removeFromCart(String productId);
  Future<Either<Failure, void>> clearCart();
}
