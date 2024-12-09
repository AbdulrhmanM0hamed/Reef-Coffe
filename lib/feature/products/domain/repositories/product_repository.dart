import 'package:dartz/dartz.dart';
import '../../../../core/error/sevcice_failure.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);
  Future<Either<Failure, List<Product>>> getAllProducts();
}
