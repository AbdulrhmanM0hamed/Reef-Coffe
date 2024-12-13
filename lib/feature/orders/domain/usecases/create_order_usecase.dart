import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(OrderEntity order) async {
    return await repository.createOrder(order);
  }
}