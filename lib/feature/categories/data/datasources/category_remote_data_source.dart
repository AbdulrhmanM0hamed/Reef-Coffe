import 'package:hyper_market/core/error/excptions.dart';

import '../../../../core/services/supabase/supabase_initialize.dart';
import '../models/category_model.dart';
import 'dart:io';
import 'package:hyper_market/core/error/network_error_handler.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseService _supabaseService;

  CategoryRemoteDataSourceImpl(this._supabaseService);

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _supabaseService.client
          .from('categories')
          .select()
          .eq('is_active', true); // فقط الفئات النشطة

      return response.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw CustomException(message: NetworkErrorHandler.getErrorMessage(e));
    }
  }
}
