import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

BottomNavyBarItem bottomNavBarIcon(
      String outlineIcon, String boldIcon, String title, bool isSelected) {
    return BottomNavyBarItem(
      icon: isSelected
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TColors.primary,
              ),
              child: SvgPicture.asset(
                boldIcon,
                width: 25,
                height: 25,
              ),
            )
          : SvgPicture.asset(
              outlineIcon,
              width: 25,
              height: 25,
            ),
      title: Text(
        title,
        style: getBoldStyle(
            fontFamily: FontConstant.cairo, fontSize: FontSize.size12),
      ),
      activeColor: TColors.primary,
    );
  }

