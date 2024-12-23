import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/excptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/sevcice_failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(categoryId);
      return Right(products);
    } catch (e) {
      if (e is PostgrestException) {
        if (e.message.contains('SocketException')) {
          throw CustomException(message: 'تحقق من اتصالك بالانترنت');
        }
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return Right(products);
    } catch (e) {
      if (e is PostgrestException) {
        if (e.message.contains('SocketException')) {
          throw CustomException(message: 'تحقق من اتصالك بالانترنت');
        }
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
