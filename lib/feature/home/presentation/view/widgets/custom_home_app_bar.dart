import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/notifications/presentation/view/notifications_view.dart';
import 'package:hyper_market/feature/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomHomeAppBar extends StatefulWidget {
  final String userName;
  const CustomHomeAppBar({super.key, required this.userName});

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {
  int _unreadCount = 0;
  late RealtimeChannel _notificationsChannel;
  late RealtimeChannel _ordersChannel;

  @override
  void initState() {
    super.initState();
    _setupRealtimeListeners();
    _loadUnreadCount();
  }

  void _setupRealtimeListeners() {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;
    
    // مراقبة جدول الإشعارات
    _notificationsChannel = supabase.channel('public:notifications')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        callback: (payload) {
          _loadUnreadCount();
        },
      )
      .subscribe();

    // مراقبة جدول الطلبات
    _ordersChannel = supabase.channel('public:orders')
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'orders',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        callback: (payload) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _loadUnreadCount();
          });
        },
      )
      .subscribe();
  }

  @override
  void dispose() {
    _notificationsChannel.unsubscribe();
    _ordersChannel.unsubscribe();
    super.dispose();
  }

  Future<void> _loadUnreadCount() async {
    final supabase = Supabase.instance.client;
    if (!mounted) return;

    try {
      final response = await supabase
          .from('notifications')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('is_read', false);

      if (mounted) {
        setState(() {
          _unreadCount = (response as List).length;
        });
      }
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'صباح الخير ...';
    } else if (hour >= 12 && hour < 17) {
      return 'مساء الخير ...';
    } else if (hour >= 17 && hour < 21) {
      return 'مساء الخير ...';
    } else {
      return 'مساء الخير ...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsLoaded) {
          setState(() {
            _unreadCount = state.notifications.where((n) => !n.isRead).length;
          });
        }
      },
      child: ListTile(
        leading: SvgPicture.asset(
          "assets/images/logo.svg",
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 18,
                  color: TColors.darkGrey),
            ),
            Text(
              widget.userName,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.white
                    : TColors.black,
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsView(),
              ),
            );
            _loadUnreadCount(); // تحديث العداد بعد العودة من صفحة الإشعارات
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: SvgPicture.asset(
                  "assets/images/notification.svg",
                  width: 24,
                  height: 24,
                ),
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 5,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
