import '../../../../core/services/supabase/supabase_initialize.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseService _supabaseService;
  final String _tableName = 'categories';

  CategoryRemoteDataSourceImpl(this._supabaseService);

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await _supabaseService.client
        .from(_tableName)
        .select()
        .eq('is_active', true); // فقط الفئات النشطة

    return response.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
