import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/notifications/data/repositories/notification_repository_impl.dart';
import 'package:hyper_market/feature/notifications/domain/repositories/notification_repository.dart';
import 'package:hyper_market/feature/notifications/presentation/view/widgets/notification_list.dart';
import 'package:hyper_market/feature/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(
        NotificationRepositoryImpl(),
      )..loadNotifications(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الإشعارات',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.white
                  : TColors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<NotificationsCubit>().clearAllNotifications();
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationsLoaded) {
              return NotificationList(notifications: state.notifications);
            } else if (state is NotificationsError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('لا توجد إشعارات'));
            }
          },
        ),
      ),
    );
  }
}
