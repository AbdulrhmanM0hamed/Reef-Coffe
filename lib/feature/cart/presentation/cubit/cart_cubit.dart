import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItem> _items = [];

  List<CartItem> getItems() {
    print('Getting cart items, count: ${_items.length}');
    return List.unmodifiable(_items);
  }

  double getTotal() {
    return _items.fold(0, (sum, item) => sum + item.getTotal());
  }

  void addItem(CartItem item) {
    print('Attempting to add item to cart: ${item.name}');
    try {
      final existingIndex = _items.indexWhere((i) => i.productId == item.productId);
      if (existingIndex >= 0) {
        print('Item already exists in cart, updating quantity');
        _items[existingIndex].quantity += item.quantity;
      } else {
        print('Adding new item to cart');
        _items.add(item);
      }
      print('Current cart items: ${_items.length}');
      // Emit new state with updated items list
      emit(CartUpdated(List.from(_items)));
      print('Cart state updated successfully');
    } catch (e) {
      print('Error adding item to cart: $e');
      // Emit current state to ensure UI is consistent
      emit(CartUpdated(List.from(_items)));
    }
  }

  void removeItem(String productId) {
    print('Attempting to remove item from cart: $productId');
    try {
      _items.removeWhere((item) => item.productId == productId);
      print('Current cart items: ${_items.length}');
      emit(CartUpdated(List.from(_items)));
      print('Cart state updated successfully');
    } catch (e) {
      print('Error removing item from cart: $e');
      emit(CartUpdated(List.from(_items)));
    }
  }

  void updateQuantity(String productId, int quantity) {
    print('Attempting to update quantity for item: $productId to $quantity');
    try {
      final index = _items.indexWhere((item) => item.productId == productId);
      if (index >= 0) {
        if (quantity <= 0) {
          _items.removeAt(index);
        } else {
          _items[index].quantity = quantity;
        }
        print('Current cart items: ${_items.length}');
        emit(CartUpdated(List.from(_items)));
        print('Cart state updated successfully');
      }
    } catch (e) {
      print('Error updating quantity: $e');
      emit(CartUpdated(List.from(_items)));
    }
  }

  void clearCart() {
    print('Clearing cart');
    try {
      _items.clear();
      emit(CartUpdated(List.from(_items)));
      print('Cart cleared successfully');
    } catch (e) {
      print('Error clearing cart: $e');
      emit(CartUpdated(List.from(_items)));
    }
  }
}
