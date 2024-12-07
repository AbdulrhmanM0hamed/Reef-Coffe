import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/core/services/supabase_service.dart';
import 'package:hyper_market/feature/dashboard/data/models/category_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final SupabaseService _supabaseService = SupabaseService();

  CategoriesCubit() : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    try {
      print('Loading categories...'); // للتتبع
      final categoriesData = await _supabaseService.getCategories();
      print('Categories data received: $categoriesData'); // للتتبع

      final categories =
          categoriesData.map((data) => CategoryModel.fromJson(data)).toList();
      print('Categories converted to models: $categories'); // للتتبع

      emit(CategoriesLoaded(categories));
    } catch (e, stackTrace) {
      print('Error in loadCategories: $e');
      print('Stack trace: $stackTrace');
      emit(CategoriesError('حدث خطأ أثناء تحميل الفئات: $e'));
    }
  }

  Future<void> createCategory(CategoryModel category) async {
    try {
      print('CategoriesCubit: Starting category creation...'); // للتتبع
      emit(CategoriesLoading());
      
      print('CategoriesCubit: Converting category to JSON...'); // للتتبع
      final categoryJson = category.toJson();
      print('CategoriesCubit: Category JSON: $categoryJson'); // للتتبع
      
      print('CategoriesCubit: Calling Supabase service...'); // للتتبع
      await _supabaseService.createCategory(categoryJson);
      print('CategoriesCubit: Category created in Supabase'); // للتتبع
      
      print('CategoriesCubit: Loading updated categories...'); // للتتبع
      await loadCategories();
      
      print('CategoriesCubit: Emitting success state...'); // للتتبع
      if (state is CategoriesLoaded) {
        emit(CategoriesLoaded((state as CategoriesLoaded).categories));
      } else {
        emit(CategoriesLoaded([]));
      }
      print('CategoriesCubit: Creation completed successfully'); // للتتبع
    } catch (e) {
      print('CategoriesCubit: Error occurred: $e'); // للتتبع
      emit(CategoriesError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateCategory(String? id, CategoryModel category) async {
    if (id == null || id.isEmpty) {
      emit(CategoriesError('معرف الفئة غير صالح'));
      return;
    }

    emit(CategoriesLoading());
    try {
      print('Updating category: $id with data: $category'); // للتتبع
      final success =
          await _supabaseService.updateCategory(id, category.toJson());
      print('Category update result: $success'); // للتتبع

      if (success) {
        await loadCategories();
      } else {
        emit(CategoriesError('فشل في تحديث الفئة'));
      }
    } catch (e, stackTrace) {
      print('Error in updateCategory: $e');
      print('Stack trace: $stackTrace');
      emit(CategoriesError('حدث خطأ أثناء تحديث الفئة: $e'));
    }
  }

  Future<void> deleteCategory(String? id) async {
    if (id == null || id.isEmpty) {
      emit(CategoriesError('معرف الفئة غير صالح'));
      return;
    }

    emit(CategoriesLoading());
    try {
      print('Deleting category: $id'); // للتتبع
      final success = await _supabaseService.deleteCategory(id);
      print('Category deletion result: $success'); // للتتبع

      if (success) {
        await loadCategories();
      } else {
        emit(CategoriesError('فشل في حذف الفئة'));
      }
    } catch (e, stackTrace) {
      print('Error in deleteCategory: $e');
      print('Stack trace: $stackTrace');
      emit(CategoriesError('حدث خطأ أثناء حذف الفئة: $e'));
    }
  }
}
