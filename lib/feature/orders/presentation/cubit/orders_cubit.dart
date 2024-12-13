import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrderUseCase getOrdersUseCase;
  final CreateOrderUseCase createOrderUseCase;

  OrdersCubit({
    required this.getOrdersUseCase,
    required this.createOrderUseCase,
  }) : super(OrdersInitial());

  Future<void> getOrders() async {
    emit(OrdersLoading());
    final result = await getOrdersUseCase();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> createOrder(OrderEntity order) async {
    emit(OrderCreating());
    final result = await createOrderUseCase(order);
    result.fold(
      (failure) => emit(OrderCreationError(failure.message)),
      (order) => emit(OrderCreated(order)),
    );
  }
}

