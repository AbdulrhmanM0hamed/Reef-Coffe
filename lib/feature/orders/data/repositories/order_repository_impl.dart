import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/excptions.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';

import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final orders = await remoteDataSource.getOrders();
      return Right(orders);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final order = await remoteDataSource.getOrderById(orderId);
      return Right(order);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      final createdOrder =
          await remoteDataSource.createOrder(order as OrderModel);
      return Right(createdOrder);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
//CustomException (PostgrestException(message: invalid input syntax for type uuid: "", code: 22P02, details: Bad Request, hint: null))
  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
      String orderId, String status) async {
    try {
      final updatedOrder =
          await remoteDataSource.updateOrderStatus(orderId, status);
      return Right(updatedOrder);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      await remoteDataSource.cancelOrder(orderId);
      return const Right(null);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
