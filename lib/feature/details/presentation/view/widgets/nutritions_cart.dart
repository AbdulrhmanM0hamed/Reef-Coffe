import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';

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
                Text(
                  item["mainText"],
                  style: TextStyle(
                    fontSize: size.width * 0.044,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (item["extraText"] != null) // النص الإضافي مثل (256)
                  Text(
                    item["extraText"],
                    style: TextStyle(
                      fontSize: size.width * 0.027,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  item["subText"],
                  style: TextStyle(
                    fontSize: size.width * 0.033,
                    color: TColors.darkGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            // الأيقونة
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  item["icon"],
                  width: size.width * 0.07,
                  height: size.height * 0.065,
                ),
                if (item["badge"] != null) // الرقم الديناميكي
                  Positioned(
                    top: size.height * 0.020,
                    right: size.width * 0.050,
                    child: Text(
                      item["badge"],
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        color: TColors.darkerGrey,
                        fontWeight: FontWeight.bold,
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
