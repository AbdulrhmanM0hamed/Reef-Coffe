import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

class LocalCartRepository {
  static const String _cartKey = 'cart_items';
  final SharedPreferences _prefs;

  LocalCartRepository(this._prefs);

  Future<List<CartItem>> getCartItems() async {
    final String? cartJson = _prefs.getString(_cartKey);
    if (cartJson == null) return [];

    final List<dynamic> cartList = json.decode(cartJson);
    return cartList.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<void> saveCartItems(List<CartItem> items) async {
    final String cartJson = json.encode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_cartKey, cartJson);
  }

  Future<void> addCartItem(CartItem item) async {
    final items = await getCartItems();
    final existingIndex = items.indexWhere((e) => e.productId == item.productId);

    if (existingIndex != -1) {
      items[existingIndex] = item;
    } else {
      items.add(item);
    }

    await saveCartItems(items);
  }

  Future<void> removeCartItem(String productId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.productId == productId);
    await saveCartItems(items);
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.productId == productId);
    
    if (index != -1) {
      items[index] = items[index].copyWith(quantity: quantity);
      await saveCartItems(items);
    }
  }

  Future<void> clearCart() async {
    await _prefs.remove(_cartKey);
  }
}
