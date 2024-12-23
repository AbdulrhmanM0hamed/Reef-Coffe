import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

BottomNavyBarItem bottomNavBarIcon(
    String outlineIcon, String boldIcon, String title, bool isSelected) {
  return BottomNavyBarItem(
    icon: Builder(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final iconSize = _getIconSize(size);
        final padding = _getPadding(size);

        return isSelected
            ? Container(
                padding: EdgeInsets.all(padding),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: TColors.primary,
                ),
                child: SvgPicture.asset(
                  boldIcon,
                  width: iconSize,
                  height: iconSize,
                ),
              )
            : SvgPicture.asset(
                outlineIcon,
                width: iconSize,
                height: iconSize,
              );
      },
    ),
    title: Builder(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final fontSize = _getFontSize(size);

        return Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: fontSize,
          ),
        );
      },
    ),
    activeColor: TColors.primary,
  );
}

double _getIconSize(Size size) {
  if (size.width < 360) {
    return 22;
  } else if (size.width < 600) {
    return 25;
  }
  return 28;
}

double _getFontSize(Size size) {
  if (size.width < 360) {
    return FontSize.size9;
  } else if (size.width < 600) {
    return FontSize.size11;
  }
  return FontSize.size13;
}

double _getPadding(Size size) {
  if (size.width < 360) {
    return 4;
  } else if (size.width < 600) {
    return 6;
  }
  return 8;
}
