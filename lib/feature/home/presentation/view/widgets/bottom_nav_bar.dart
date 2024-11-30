import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

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
      showElevation: true, // use this to remove appBar's elevation
      onItemSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget.pageController.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      },
      items: [
        BottomNavyBarItem(
          icon: _currentIndex == 0
              ? Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColors.primary,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/vuesax/bold/home2.svg',
                   
                    width: 23,
                    height: 23,
                  ),
                )
              : SvgPicture.asset(
                'assets/images/vuesax/outline/homeOutline.svg' ,
                width: 30,
                height: 30,
              ),
          title: Text('الرئيسية' , style: getBoldStyle(fontFamily: FontConstant.cairo , fontSize: FontSize.size12),),
          activeColor: TColors.primary,
        ),
        BottomNavyBarItem(
          icon: _currentIndex == 1
              ? Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColors.primary,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/vuesax/bold/products.svg',
                    width: 25,
                    height: 25,
                  ),
                )
              : SvgPicture.asset(
                'assets/images/vuesax/outline/products.svg',
                width: 25,
                height: 25,
              ),
          title: Text('المنتجات' , style: getBoldStyle(fontFamily: FontConstant.cairo , fontSize: FontSize.size12),),
          activeColor: TColors.primary,
        ),
        BottomNavyBarItem(
          icon: _currentIndex == 2
              ? Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColors.primary,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/vuesax/bold/shopping-cart.svg',
                    width: 25,
                    height: 25,
                  ),
                )
              : SvgPicture.asset(
                'assets/images/vuesax/outline/shopping-cart.svg',
                width: 25,
                height: 25,
              ),
          title: Text('سلة التسوق' , style: getBoldStyle(fontFamily: FontConstant.cairo , fontSize: FontSize.size12),),
          activeColor: TColors.primary,
        ),
        BottomNavyBarItem(
          icon: _currentIndex == 3
              ? Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColors.primary,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/vuesax/bold/user.svg',
                    width: 25,
                    height: 25,
                  ),
                )
              : SvgPicture.asset(
                'assets/images/vuesax/outline/user.svg',
                width: 25,
                height: 25,
              ),
          title: Text(' حسابى' , style: getBoldStyle(fontFamily: FontConstant.cairo , fontSize: FontSize.size12),),
          activeColor: TColors.primary,
        ),
      ],
    );
  }
}
