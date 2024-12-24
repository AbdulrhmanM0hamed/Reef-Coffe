import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/feature/products/data/models/product_model.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  String? _userId;
  final Set<String> _favoriteIds = {};
  final List<ProductModel> _favorites = [];

  FavoriteCubit() : super(FavoriteInitial()) {
    _loadUserId().then((_) => _loadFavorites());
  }

  Future<void> _loadUserId() async {
    final userDataJson = await Prefs.getString(KUserData);
    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        final userData = json.decode(userDataJson);
        _userId = userData['id'];
      } catch (e) {
        debugPrint('Error parsing user data: $e');
      }
    }
  }

  Future<void> updateUserId() async {
    String? newUserId;
    final userDataJson = await Prefs.getString(KUserData);
    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        final userData = json.decode(userDataJson);
        newUserId = userData['id'];
      } catch (e) {
        debugPrint('Error parsing user data: $e');
      }
    }

    if (_userId != newUserId) {
      _userId = newUserId;
      await _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    if (_userId == null) {
      if (!isClosed) emit(FavoriteLoaded(favorites: []));
      return;
    }

    try {
      final favoritesJson = await Prefs.getString('favorites_${_userId}');
      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(favoritesJson);
        _favorites.clear();
        _favoriteIds.clear();
        
        for (var item in decoded) {
          final product = ProductModel.fromJson(item);
          _favorites.add(product);
          _favoriteIds.add(product.id!);
        }
      }
      if (!isClosed) emit(FavoriteLoaded(favorites: List.from(_favorites)));
    } catch (e) {
      if (!isClosed) emit(FavoriteError('Error loading favorites: $e'));
    }
  }

  Future<void> _saveFavorites() async {
    if (_userId == null) return;
    
    try {
      final encoded = json.encode(_favorites.map((e) => e.toJson()).toList());
      await Prefs.setString('favorites_${_userId}', encoded);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> toggleFavorite(Product product) async {
    if (_userId == null || isClosed) return;

    try {
      if (_favoriteIds.contains(product.id)) {
        _favoriteIds.remove(product.id);
        _favorites.removeWhere((p) => p.id == product.id);
      } else {
        _favoriteIds.add(product.id!);
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          categoryId: product.categoryId,
          hasDiscount: product.hasDiscount,
          discountPercentage: product.discountPercentage,
          discountPrice: product.discountPrice,
          soldCount: product.soldCount,
          isAvailable: product.isAvailable,
          stock: product.stock,
          isOrganic: product.isOrganic,
          rating: product.rating,
          ratingCount: product.ratingCount,
          caloriesPer100g: product.caloriesPer100g,
          expiryName: product.expiryName,
          weight: product.weight,
        );
        _favorites.add(productModel);
      }
      
      await _saveFavorites();
      if (!isClosed) emit(FavoriteLoaded(favorites: List.from(_favorites)));
    } catch (e) {
      if (!isClosed) emit(FavoriteError('Error updating favorites: $e'));
    }
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  List<Product> getFavorites() {
    return List.unmodifiable(_favorites.map((e) => Product(
      id: e.id,
      name: e.name,
      description: e.description,
      price: e.price,
      imageUrl: e.imageUrl,
      categoryId: e.categoryId,
      hasDiscount: e.hasDiscount,
      discountPercentage: e.discountPercentage,
      discountPrice: e.discountPrice,
      soldCount: e.soldCount,
      isAvailable: e.isAvailable,
      stock: e.stock,
      isOrganic: e.isOrganic,
      rating: e.rating,
      ratingCount: e.ratingCount,
      caloriesPer100g: e.caloriesPer100g,
      expiryName: e.expiryName,
      weight: e.weight,
    )).toList());
  }
}
