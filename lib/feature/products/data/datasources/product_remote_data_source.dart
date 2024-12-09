import '../../../../core/services/supabase/supabase_initialize.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> getAllProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final SupabaseService _supabaseService;
  final String _tableName = 'products';

  ProductRemoteDataSourceImpl(this._supabaseService);

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final response = await _supabaseService.client
        .from(_tableName)
        .select()
        .eq('category_id', categoryId)
        .eq('is_available', true); 

    return response.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _supabaseService.client
        .from(_tableName)
        .select()
        .eq('is_available', true);

    return response.map((json) => ProductModel.fromJson(json)).toList();
  }
}
