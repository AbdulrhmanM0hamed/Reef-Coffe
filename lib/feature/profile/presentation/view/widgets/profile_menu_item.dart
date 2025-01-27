import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

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
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 16,
      
        ),
      ),
      trailing:const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: TColors.darkGrey,
      ),
      onTap: onTap,
    );
  }
}
