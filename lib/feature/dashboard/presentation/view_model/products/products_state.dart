part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {}

class ProductsFetched extends ProductsState {
  final List<ProductModel> products;
  ProductsFetched(this.products);
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}
