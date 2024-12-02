import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:hyper_market/core/utils/helper/bottom_nav_bar_icon_method.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar(
      {super.key,
      required this.pageController,
      required this.currentIndex,
      required this.onIndexChanged});

  final PageController pageController;
  final int currentIndex; // تمرير الفهرس الحالي
  final Function(int) onIndexChanged; // تعريف دالة لتغيير الفهرس

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: widget.currentIndex,
      showElevation: true,
      onItemSelected: (index) {
        widget.onIndexChanged(index); // تحديث الفهرس عند اختياره
        widget.pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
      items: <BottomNavyBarItem>[
        bottomNavBarIcon(
          'assets/images/vuesax/outline/homeOutline.svg',
          'assets/images/vuesax/bold/home2.svg',
          'الرئيسية',
          widget.currentIndex == 0,
        ),
        bottomNavBarIcon(
          'assets/images/vuesax/outline/products.svg',
          'assets/images/vuesax/bold/products.svg',
          'المنتجات',
          widget.currentIndex == 1,
        ),
        bottomNavBarIcon(
          'assets/images/vuesax/outline/shopping-cart.svg',
          'assets/images/vuesax/bold/shopping-cart.svg',
          'سلة التسوق',
          widget.currentIndex == 2,
        ),
        bottomNavBarIcon(
          'assets/images/vuesax/outline/user.svg',
          'assets/images/vuesax/bold/user.svg',
          ' حسابى',
          widget.currentIndex == 3,
        ),
      ],
    );
  }
}
