import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/helper/bottom_nav_bar_icon_method.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key, required this.pageController});
  final PageController pageController;
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: _currentIndex,
      showElevation: true,
      onItemSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget.pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
      items: <BottomNavyBarItem>[
        bottomNavBarIcon(
          'assets/images/vuesax/outline/homeOutline.svg',
          'assets/images/vuesax/bold/home2.svg',
          'الرئيسية',
          _currentIndex == 0,
        ),
        bottomNavBarIcon(
          'assets/images/vuesax/outline/products.svg',
          'assets/images/vuesax/bold/products.svg',
          'المنتجات',
          _currentIndex == 1,
        ),
        bottomNavBarIcon(
          'assets/images/vuesax/outline/shopping-cart.svg',
          'assets/images/vuesax/bold/shopping-cart.svg',
          'سلة التسوق',
          _currentIndex == 2,
        ),
        bottomNavBarIcon(
          'assets/images/vuesax/outline/user.svg',
          'assets/images/vuesax/bold/user.svg',
          ' حسابى',
          _currentIndex == 3,
        ),
      ],
    );
  }
}
