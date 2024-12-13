import 'package:hyper_market/core/error/excptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrderStatus(String orderId, String status);
  Future<void> cancelOrder(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final SupabaseClient supabaseClient;

  OrderRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null)
        throw const CustomException(message: 'User ID is null');

      final response = await supabaseClient
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } catch (e) {
      throw CustomException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null)
        throw const CustomException(message: 'User ID is null');

      final response = await supabaseClient
          .from('orders')
          .select()
          .eq('id', orderId)
          .eq('user_id', userId)
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null)
        throw const CustomException(message: 'User ID is null');

      final orderData = order.toJson();
      orderData['user_id'] = userId;
      orderData['created_at'] = DateTime.now().toIso8601String();
      orderData['status'] = 'pending'; // Initial status

      final response = await supabaseClient
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null)
        throw const CustomException(message: 'User ID is null');

      final response = await supabaseClient
          .from('orders')
          .update({'status': status})
          .eq('id', orderId)
          .eq('user_id', userId)
          .select()
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null)
        throw const CustomException(message: 'User ID is null');

      await supabaseClient
          .from('orders')
          .update({'status': 'cancelled'})
          .eq('id', orderId)
          .eq('user_id', userId);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
