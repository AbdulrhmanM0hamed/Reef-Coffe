import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<Failure, OrderEntity>> updateOrderStatus(String orderId, String status);
  Future<Either<Failure, void>> cancelOrder(String orderId);
}
