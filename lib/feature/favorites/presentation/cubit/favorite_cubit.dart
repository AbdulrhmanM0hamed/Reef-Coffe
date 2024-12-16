import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/feature/products/data/models/product_model.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final String? userId;
  final List<Product> _favorites = [];

  FavoriteCubit({this.userId}) : super(FavoriteInitial()) {
    _loadFavorites();
  }

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  void toggleFavorite(Product product) {
    final isCurrentlyFavorite = isFavorite(product.id!);
    if (isCurrentlyFavorite) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      final productModel = ProductModel(
        id: product.id!,
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
        expiryNumber: product.expiryNumber,
      );
      _favorites.add(productModel);
    }
    _saveFavorites();
    emit(FavoriteUpdated(List.from(_favorites)));
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
    emit(FavoriteUpdated([]));
  }

  Future<void> _loadFavorites() async {
    try {
      final key = userId != null ? '${KUserFavorites}$userId' : KUserFavorites;
      final favoritesJson = Prefs.getString(key);
      
      // Initialize empty list if no favorites exist
      if (favoritesJson == null) {
        await Prefs.setString(key, '[]');
        _favorites.clear();
        emit(FavoriteUpdated([]));
        return;
      }

      // Parse existing favorites
      final List<dynamic> decodedList = jsonDecode(favoritesJson);
      _favorites.clear();
      _favorites.addAll(
        decodedList.map((item) => ProductModel.fromJson(item)).toList(),
      );
      emit(FavoriteUpdated(List.from(_favorites)));
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      // Initialize with empty list on error
      _favorites.clear();
      emit(FavoriteUpdated([]));
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final key = userId != null ? '${KUserFavorites}$userId' : KUserFavorites;
      final favoritesJson = jsonEncode(
        _favorites.map((p) => (p as ProductModel).toJson()).toList(),
      );
      await Prefs.setString(key, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }
}
