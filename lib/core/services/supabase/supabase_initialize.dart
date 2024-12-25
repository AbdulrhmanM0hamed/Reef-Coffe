import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient _client;

  Future<void> initialize({
    required String supabaseUrl,
    required String supabaseKey,
  }) async {
    try {
      
      // تكوين عنوان Realtime
      final realtimeUrl = 'wss://kizgmgaocdhnarvqtzvf.supabase.co/realtime/v1/websocket';
      
      final realtimeOptions = RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
        eventsPerSecond: 10,
      
      );

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
        debug: true,
        realtimeClientOptions: realtimeOptions,
      );

      _client = Supabase.instance.client;
   

      // إعداد اتصال Realtime
      await _setupRealtimeConnection();

    } catch (e) {
      rethrow;
    }
  }

  Future<void> _setupRealtimeConnection() async {
    try {
      // تأكد من قطع أي اتصال سابق
      if (_client.realtime.isConnected) {
        await _client.realtime.disconnect();
        await Future.delayed(const Duration(seconds: 1));
      }
      
     
      
      // إنشاء القناة
      final channel = _client.channel('realtime:*');

      // الاشتراك في القناة
      channel.subscribe((status, [error]) {
        if (error != null) {
      
          _reconnectRealtimeAfterDelay();
        } else if (status == 'SUBSCRIBED') {
          print('✅ Channel subscribed successfully');
          // اختبار الاتصال
      
        }
      });

      // تأكيد الاتصال
      await _client.realtime.connect();
   

    } catch (e, stackTrace) {
   
      _reconnectRealtimeAfterDelay();
    }
  }

  Future<void> _reconnectRealtimeAfterDelay() async {
    await Future.delayed(const Duration(seconds: 5));
    try {
      if (_client.realtime.isConnected) {
        await _client.realtime.disconnect();
      }
      await Future.delayed(const Duration(seconds: 1));
      await _setupRealtimeConnection();
;
    } catch (e) {
    }
  }

  SupabaseClient get client => _client;
}
