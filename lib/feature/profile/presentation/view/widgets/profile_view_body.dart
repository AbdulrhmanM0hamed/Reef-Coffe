import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

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
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  'تسجيل الخروج',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: 16,
                    color: Colors.red,
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

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: TColors.secondary,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/profile_image.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'عبدالرحمن محمد',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: 20,
            color: Theme.of(context).brightness == Brightness.dark 
              ? TColors.white 
              : TColors.black,
          ),
        ),
        Text(
          'abdo@gmail.com',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: 14,
            color: TColors.darkGrey,
          ),
        ),
      ],
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: TColors.primary),
      title: Text(
        title,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark 
            ? TColors.white 
            : TColors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: TColors.darkGrey,
      ),
      onTap: onTap,
    );
  }
}

class ProfileMenuSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProfileMenuSwitch({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: TColors.primary),
      title: Text(
        title,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark 
            ? TColors.white 
            : TColors.black,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: TColors.primary,
      ),
    );
  }
}
