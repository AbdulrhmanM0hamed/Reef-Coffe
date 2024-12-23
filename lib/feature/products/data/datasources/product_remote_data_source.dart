import 'package:hyper_market/core/error/excptions.dart';

import '../../../../core/services/supabase/supabase_initialize.dart';
import '../models/product_model.dart';
import 'dart:io';
import 'package:hyper_market/core/error/network_error_handler.dart';

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
    try {
      final response = await _supabaseService.client
          .from(_tableName)
          .select()
          .eq('category_id', categoryId)
          .eq('is_available', true);

      return response.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw CustomException(message: NetworkErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _supabaseService.client
          .from(_tableName)
          .select()
          .eq('is_available', true);

      return response.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw CustomException(message: NetworkErrorHandler.getErrorMessage(e));
    }
  }
}
