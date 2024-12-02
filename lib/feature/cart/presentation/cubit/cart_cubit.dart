import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(0, (sum, item) => sum + item.total);

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.productId == item.productId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(item);
    }
    emit(CartUpdated(List.from(_items)));
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
