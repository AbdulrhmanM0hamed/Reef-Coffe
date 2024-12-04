import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

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
