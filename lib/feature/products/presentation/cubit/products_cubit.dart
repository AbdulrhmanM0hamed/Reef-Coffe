import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository productRepository;
  List<Product> _allProducts = [];
  String _currentQuery = '';

  ProductsCubit(this.productRepository) : super(ProductsInitial());

  Future<void> getProductsByCategory(String? categoryId) async {
    if (isClosed) return;
    if (categoryId == null) return;
    
    emit(ProductsLoading());

    if (isClosed) return;

    final result = await productRepository.getProductsByCategory(categoryId);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(ProductsError(failure.message));
        }
      },
      (products) {
        if (!isClosed) {
          _allProducts = products;
          emit(ProductsLoaded(products));
        }
      },
    );
  }

  Future<void> getAllProducts() async {
    if (isClosed) return;
    
    emit(ProductsLoading());

    if (isClosed) return;

    final result = await productRepository.getAllProducts();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(ProductsError(failure.message));
        }
      },
      (products) {
        if (!isClosed) {
          _allProducts = products;
          emit(ProductsLoaded(products));
        }
      },
    );
  }

  void searchProducts(String query) {
    if (isClosed) return;
    
    _currentQuery = query.trim();
    
    if (_currentQuery.isEmpty) {
      emit(ProductsLoaded(_allProducts));
      return;
    }

    final searchQuery = _normalizeArabicText(_currentQuery.toLowerCase());
    
    final filteredProducts = _allProducts.where((product) {
      final normalizedName = _normalizeArabicText(product.name.toLowerCase());
      final normalizedDescription = product.description != null 
          ? _normalizeArabicText(product.description!.toLowerCase())
          : '';
          
      // Check for exact word matches first
      final searchWords = searchQuery.split(' ');
      final nameWords = normalizedName.split(' ');
      final descriptionWords = normalizedDescription.split(' ');
      
      bool hasExactMatch = searchWords.any((word) => 
        nameWords.contains(word) || descriptionWords.contains(word));
      
      // If no exact match, check for partial matches
      bool hasPartialMatch = !hasExactMatch && (
        normalizedName.contains(searchQuery) || 
        normalizedDescription.contains(searchQuery)
      );

      return hasExactMatch || hasPartialMatch;
    }).toList();

    emit(ProductsLoaded(filteredProducts));
  }

  String _normalizeArabicText(String text) {
    if (text.isEmpty) return '';
    
    // Remove diacritics
    final normalized = text
        .replaceAll('\u064B', '') // فتحتين
        .replaceAll('\u064C', '') // ضمتين
        .replaceAll('\u064D', '') // كسرتين
        .replaceAll('\u064E', '') // فتحة
        .replaceAll('\u064F', '') // ضمة
        .replaceAll('\u0650', '') // كسرة
        .replaceAll('\u0651', '') // شدة
        .replaceAll('\u0652', '') // سكون
        // Normalize Alef forms
        .replaceAll('\u0622', '\u0627') // Alef with madda
        .replaceAll('\u0623', '\u0627') // Alef with hamza above
        .replaceAll('\u0625', '\u0627') // Alef with hamza below
        // Normalize Ya and Alef Maksura
        .replaceAll('\u0649', '\u064A') // Alef maksura to Ya
        .trim();
        
    return normalized;
  }

  void filterProducts({
    required double minPrice,
    required double maxPrice,
    required bool isNatural,
    required bool hasDiscount,
  }) {
    final filteredProducts = _allProducts.where((product) {
      bool priceInRange = product.price >= minPrice && product.price <= maxPrice;
      bool naturalMatch = !isNatural || product.isOrganic;
      bool discountMatch = !hasDiscount || (product.hasDiscount && (product.discountPrice ?? 0) > 0);
      
      return priceInRange && naturalMatch && discountMatch;
    }).toList();

    emit(ProductsLoaded(filteredProducts));
  }
}
