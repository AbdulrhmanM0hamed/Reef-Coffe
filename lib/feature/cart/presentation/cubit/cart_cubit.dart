import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItem> _items = [];

  List<CartItem> getItems() {
   
    return List.unmodifiable(_items);
  }

  double getTotal() {
    return _items.fold(0, (sum, item) => sum + item.getTotal());
  }

  void addItem(CartItem item) {
    try {
   
      
      if (item.price == null || item.price! <= 0) {
        throw Exception('Invalid price for item: ${item.name}');
      }

      if (item.quantity <= 0) {
        throw Exception('Invalid quantity for item: ${item.name}');
      }

      final existingIndex = _items.indexWhere((i) => i.productId == item.productId);
     
      if (existingIndex != -1) {
      
        _items[existingIndex].quantity += item.quantity;
      } else {
        _items.add(item);
      }

    
      
      // Force a state update by creating a new list
      emit(CartUpdated([..._items]));
    } catch (e) {
      rethrow;
    }
  }

  void removeItem(String productId) {
    List<CartItem> updatedItems = List.from(_items);
    updatedItems.removeWhere((item) => item.productId == productId);
    _items.clear();
    _items.addAll(updatedItems);
    emit(CartUpdated(List.from(_items)));
    }

  void updateQuantity(String productId, int quantity) {
    List<CartItem> updatedItems = List.from(_items);
    final index = updatedItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        updatedItems.removeAt(index);
      } else {
        updatedItems[index].quantity = quantity;
      }
    }
    _items.clear();
    _items.addAll(updatedItems);
    emit(CartUpdated(List.from(_items)));
  }

  void clearCart() {
    if (!isClosed) {
      _items.clear();
     
      emit(CartUpdated(List.from(_items)));
    }
  }
}
