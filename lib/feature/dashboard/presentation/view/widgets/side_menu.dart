import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: TColors.primary,
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo or Title
          Text(
            'لوحة التحكم',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          _buildMenuItem(
            index: 0,
            title: 'لوحة التحكم',
            icon: Icons.dashboard,
          ),
          _buildMenuItem(
            index: 1,
            title: 'المنتجات',
            icon: Icons.shopping_bag,
          ),
          _buildMenuItem(
            index: 2,
            title: 'التصنيفات',
            icon: Icons.category,
          ),
          _buildMenuItem(
            index: 3,
            title: 'الطلبات',
            icon: Icons.shopping_cart,
          ),
          _buildMenuItem(
            index: 4,
            title: 'المستخدمين',
            icon: Icons.people,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white70,
      ),
      title: Text(
        title,
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size16,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
      selected: isSelected,
      onTap: () => onItemSelected(index),
      selectedTileColor: Colors.white.withOpacity(0.1),
    );
  }
}
