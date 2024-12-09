import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class CalendarWithNumber extends StatelessWidget {
  final String number;

  const CalendarWithNumber({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/calener.svg',
          width: 40,
          height: 40,
          colorFilter: ColorFilter.mode(
            TColors.primary,
            BlendMode.srcIn,
          ),
        ),
        Positioned(
          top: 15,
          child: Text(
            number,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: 14,
              color: TColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
