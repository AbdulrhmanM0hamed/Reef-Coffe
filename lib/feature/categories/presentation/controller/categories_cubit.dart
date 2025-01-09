import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/category_repository.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository _repository;

  CategoriesCubit(this._repository) : super(CategoriesInitial());

  Future<void> getAllCategories() async {
    if (isClosed) return;
    emit(CategoriesLoading());
    final result = await _repository.getAllCategories();
    if (isClosed) return;
    result.fold(
      (failure) => emit(const CategoriesError('فشل في تحميل الفئات')),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}
