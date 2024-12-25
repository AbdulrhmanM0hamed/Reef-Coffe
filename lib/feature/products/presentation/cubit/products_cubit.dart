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
    
    _currentQuery = query.trim(); // إزالة المسافات الزائدة
    
    if (_currentQuery.isEmpty) {
      emit(ProductsLoaded(_allProducts));
      return;
    }

    // تحويل النص للحروف الصغيرة وإزالة التشكيل
    final searchQuery = _normalizeArabicText(_currentQuery.toLowerCase());
    
    final filteredProducts = _allProducts.where((product) {
      // تطبيق نفس المعالجة على اسم المنتج والوصف
      final normalizedName = _normalizeArabicText(product.name.toLowerCase());
      final normalizedDescription = product.description != null 
          ? _normalizeArabicText(product.description.toLowerCase())
          : '';
          
      // البحث عن تطابق جزئي
      return normalizedName.contains(searchQuery) || 
             normalizedDescription.contains(searchQuery);
    }).toList();

    emit(ProductsLoaded(filteredProducts));
  }

  // دالة لمعالجة النص العربي
  String _normalizeArabicText(String text) {
    // إزالة التشكيل
    final normalized = text
        .replaceAll('\u064B', '') // فتحتين
        .replaceAll('\u064C', '') // ضمتين
        .replaceAll('\u064D', '') // كسرتين
        .replaceAll('\u064E', '') // فتحة
        .replaceAll('\u064F', '') // ضمة
        .replaceAll('\u0650', '') // كسرة
        .replaceAll('\u0651', '') // شدة
        .replaceAll('\u0652', ''); // سكون
        
    return normalized;
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
