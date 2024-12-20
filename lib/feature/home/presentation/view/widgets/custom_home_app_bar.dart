import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/notifications/presentation/view/notifications_view.dart';

class CustomHomeAppBar extends StatelessWidget {
  final String userName;
  const CustomHomeAppBar({super.key, required this.userName});

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
    return ListTile(
      leading: Image.asset("assets/images/profile_image.png"),
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
            userName,
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsView(),
              ),
            );
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            );
          },
          child: SvgPicture.asset(
            "assets/images/notification.svg",
            width: 24,
            height: 24,
          )),
    );
  }
}
