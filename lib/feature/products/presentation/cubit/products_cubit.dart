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
    _currentQuery = query.toLowerCase();
    if (_currentQuery.isEmpty) {
      if (!isClosed) {
        emit(ProductsLoaded(_allProducts));
      }
      return;
    }

    final filteredProducts = _allProducts.where((product) {
      final name = product.name.toLowerCase();
      final description = product.description!.toLowerCase();
      return name.contains(_currentQuery) || description.contains(_currentQuery);
    }).toList();

    if (!isClosed) {
      emit(ProductsLoaded(filteredProducts));
    }
  }

  void filterProducts({
    required double minPrice,
    required double maxPrice,
    required bool isNatural,
    required bool hasDiscount,
  }) {
    if (isClosed) return;
    var filteredProducts = _allProducts.where((product) {
      bool priceInRange = product.price >= minPrice && product.price <= maxPrice;
      bool naturalMatch = !isNatural || product.isOrganic;
      bool discountMatch = !hasDiscount || (product.hasDiscount && (product.discountPrice ?? 0) > 0);
      
      return priceInRange && naturalMatch && discountMatch;
    }).toList();

    if (_currentQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.name.toLowerCase().contains(_currentQuery);
      }).toList();
    }

    if (!isClosed) {
      emit(ProductsLoaded(filteredProducts));
    }
  }
}
