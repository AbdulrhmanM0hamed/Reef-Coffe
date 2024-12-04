import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profiel_menu_switch.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_header.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_menu_item.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            const ProfileHeader(),
            const SizedBox(height: 24),
            
            // Profile Menu Items
            ProfileMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'طلباتي',
              onTap: () {
                // Navigate to orders
              },
            ),
            ProfileMenuItem(
              icon: Icons.payment_outlined,
              title: 'المدفوعات',
              onTap: () {
                // Navigate to payments
              },
            ),
            ProfileMenuItem(
              icon: Icons.favorite_border,
              title: 'المفضلة',
              onTap: () {
                // Navigate to favorites
              },
            ),
            ProfileMenuSwitch(
              icon: Icons.notifications_outlined,
              title: 'الاشعارات',
              value: true,
              onChanged: (value) {
                // Handle notifications toggle
              },
            ),
            ProfileMenuSwitch(
              icon: Icons.dark_mode_outlined,
              title: 'الوضع الليلي',
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                // Handle theme toggle
              },
            ),
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'المساعدة',
              onTap: () {
                // Navigate to help
              },
            ),
            ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'من نحن',
              onTap: () {
                // Navigate to about
              },
            ),
            const SizedBox(height: 24),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle logout
                },
                icon: const Icon(Icons.logout, color: TColors.darkGrey,),
                label: Text(
                  'تسجيل الخروج',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: 16,
                    color: TColors.darkGrey,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 243, 56).withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




