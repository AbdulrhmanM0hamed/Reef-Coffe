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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;
        final isTablet = MediaQuery.of(context).size.width >= 768;
        
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? TColors.darkerGrey
                : TColors.white,
            borderRadius: BorderRadius.circular(cardWidth * 0.03),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: cardWidth * 0.005,
                offset: Offset(0, cardWidth * 0.005),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(cardWidth * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // النصوص
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item["mainText"],
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: isTablet ? cardWidth * 0.035 : cardWidth * 0.044,
                          color: TColors.primary,
                        ),
                      ),
                      if (item["extraText"] != null)
                        Text(
                          item["extraText"],
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: isTablet ? cardWidth * 0.025 : cardWidth * 0.030,
                            color: TColors.darkGrey,
                          ),
                        ),
                      SizedBox(height: cardHeight * 0.01),
                      Text(
                        item["subText"],
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: isTablet ? cardWidth * 0.024 : cardWidth * 0.029,
                          color: TColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        item["icon"],
                        width: isTablet ? cardWidth * 0.06 : cardWidth * 0.07,
                        height: isTablet ? cardHeight * 0.055 : cardHeight * 0.065,
                        fit: BoxFit.contain,
                      ),
                      if (item["badge"] != null)
                        Transform.translate(
                          offset: Offset(0, cardHeight * 0.02),
                          child: Text(
                            item["badge"],
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: isTablet ? cardWidth * 0.05 : cardWidth * 0.060,
                              color: TColors.darkerGrey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
