import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class NutritionsCart extends StatelessWidget {
  const NutritionsCart({
    super.key,
    required this.item,
    required this.size,
  });

  final Map<String, dynamic> item;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? TColors.darkerGrey
            : TColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // النصوص
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item["mainText"],
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: size.width * 0.044,
                        color: TColors.primary)),
                if (item["extraText"] != null)
                  Text(item["extraText"],
                      style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: size.width * 0.030,
                          color: TColors.darkGrey)),
                const SizedBox(height: 2),
                Text(
                  item["subText"],
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: size.width * 0.029,
                      color: TColors.darkGrey),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  item["icon"],
                  width: size.width * 0.07,
                  height: size.height * 0.065,
                ),
                if (item["badge"] != null) 
                  Transform.translate(
                    offset: const Offset(0, 5),
                    child: Text(
                      item["badge"],
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: size.width * 0.060,
                        color: TColors.darkerGrey,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
