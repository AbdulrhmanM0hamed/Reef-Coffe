import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItem> _items = [];

  List<CartItem> getItems() {
    print('Debug: Getting items from cart. Count: ${_items.length}');
    print('Debug: Items: ${_items.map((e) => '${e.name} (${e.quantity})').join(', ')}');
    return List.unmodifiable(_items);
  }

  double getTotal() {
    return _items.fold(0, (sum, item) => sum + item.getTotal());
  }

  void addItem(CartItem item) {
    try {
      print('Debug: Adding item to cart: ${item.name}');
      if (item.price == null || item.price! <= 0) {
        throw Exception('Invalid price for item: ${item.name}');
      }

      if (item.quantity <= 0) {
        throw Exception('Invalid quantity for item: ${item.name}');
      }

      final existingIndex =
          _items.indexWhere((i) => i.productId == item.productId);
      print('Debug: Existing item index: $existingIndex');
      
      if (existingIndex != -1) {
        print('Debug: Updating existing item quantity');
        _items[existingIndex].quantity += item.quantity;
      } else {
        print('Debug: Adding new item to cart');
        _items.add(item);
      }

      print('Debug: Cart items after update: ${_items.length}');
      emit(CartUpdated(List.from(_items)));
    } catch (e) {
      print('Error adding item to cart: $e');
      throw e;
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    emit(CartUpdated(List.from(_items)));
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      emit(CartUpdated(List.from(_items)));
    }
  }

  void clearCart() {
    _items.clear();
    emit(CartUpdated(List.from(_items)));
  }
}
