import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderUseCase {
  final OrderRepository repository;

  GetOrderUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await repository.getOrders();
  }
}
