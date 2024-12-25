// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:hyper_market/core/services/service_locator.dart';
// import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:http/http.dart' as http;

// class NotificationService {
//   final _client = getIt<SupabaseService>().client;
  
//   Future<void> initialize() async {
//     debugPrint('🔔 Initializing NotificationService...');
    
//     // Initialize OneSignal with high priority settings
//     OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//     OneSignal.initialize("b0e37948-f397-43c0-9c5a-06d80a592c8a");
    
//     // Configure notification settings for all states
//     await OneSignal.Notifications.requestPermission(true);
    
//     // Set up notification handlers for different app states
//     OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//       debugPrint('🔔 Notification will display in foreground: ${event.notification.additionalData}');
//       event.notification.display();
//     });
    
//     OneSignal.Notifications.addClickListener((event) {
//       debugPrint('🔔 Notification clicked: ${event.notification.additionalData}');
//       _handleNotificationClick(event.notification);
//     });
    
//     _setupOrderStatusListener();
//     debugPrint('🔔 NotificationService initialized successfully');
//   }

//   void _handleNotificationClick(OSNotification notification) {
//     try {
//       final data = notification.additionalData;
//       if (data != null && data['order_id'] != null) {
//         // Handle navigation or any other action based on notification data
//         debugPrint('🔔 Handling notification click for order: ${data['order_id']}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error handling notification click: $e');
//     }
//   }

//   void _setupOrderStatusListener() {
//     debugPrint('🔔 Setting up order status listener...');
//     final supabase = Supabase.instance.client;
    
//     supabase
//         .channel('public:orders')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.update,
//           schema: 'public',
//           table: 'orders',
//           callback: (payload) async {
//             debugPrint('🔔 Order status changed: ${payload.newRecord}');
            
//             final userId = supabase.auth.currentUser?.id;
//             final orderUserId = payload.newRecord['user_id'] as String?;
//             final status = payload.newRecord['status'] as String?;
            
//             debugPrint('🔔 Current user: $userId, Order user: $orderUserId');
            
//             if (userId != null && userId == orderUserId && status != null) {
//               final playerId = OneSignal.User.pushSubscription.id;
//               debugPrint('🔔 Current OneSignal Player ID: $playerId');
              
//               if (playerId != null) {
//                 try {
//                   final response = await http.post(
//                     Uri.parse('https://onesignal.com/api/v1/notifications'),
//                     headers: {
//                       'accept': 'application/json',
//                       'Content-Type': 'application/json',
//                       'Authorization': 'os_v2_app_wdrxsshts5b4bhc2a3mauwjmrj5k5rnn5ayen3f6xbz63lyz56hvs2rd4clmzo3bvo5cesqbwsgep3baiynaz4avs7czblmaubw564a'
//                     },
//                     body: jsonEncode({
//                       'app_id': 'b0e37948-f397-43c0-9c5a-06d80a592c8a',
//                       'include_player_ids': [playerId],
//                       'contents': {'en': _getStatusMessage(status)},
//                       'headings': {'en': 'تحديث حالة الطلب'},
//                       'data': {'order_id': payload.newRecord['id']},
//                       'priority': 10,
//                       'android_group': 'order_status',
//                       'android_group_message': {'en': 'تحديثات الطلبات'},
//                       'android_sound': 'notification',
//                       'android_visibility': 1,
//                       'collapse_id': 'order_${payload.newRecord['id']}',
//                       'ttl': 86400
//                     }),
//                   );
                  
//                   debugPrint('🔔 Request Headers: ${response.request?.headers}');
//                   debugPrint('🔔 Response Status Code: ${response.statusCode}');
//                   final responseData = jsonDecode(response.body);
//                   debugPrint('🔔 OneSignal Response: $responseData');
                  
//                   if (response.statusCode != 200) {
//                     debugPrint('❌ Error sending notification: ${response.body}');
//                   } else {
//                     debugPrint('✅ Notification sent successfully');
//                   }
//                 } catch (e) {
//                   debugPrint('❌ Error sending notification: $e');
//                 }
//               } else {
//                 debugPrint('❌ No OneSignal Player ID found');
//               }
//             }
//           },
//         )
//         .subscribe();
    
//     debugPrint('🔔 Order status listener set up successfully');
//   }

//   String _getStatusMessage(String status) {
//     switch (status) {
//       case 'pending':
//         return 'تم استلام طلبك وفي انتظار المراجعة';
//       case 'processing':
//         return 'جاري تجهيز طلبك';
//       case 'completed':
//         return 'تم اكتمال طلبك بنجاح';
//       case 'cancelled':
//         return 'تم إلغاء الطلب';
//       case 'delivered':
//         return 'تم توصيل طلبك بنجاح';
//       default:
//         return 'تم تحديث حالة طلبك إلى: $status';
//     }
//   }
// }