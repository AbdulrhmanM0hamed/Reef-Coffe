import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

// class InfoSection extends StatelessWidget {
//   final Product product;

//   const InfoSection({
//     Key? key,
//     required this.product,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'معلومات المنتج',
//           style: getBoldStyle(
//             fontFamily: FontConstant.cairo,
//             fontSize: size.width * 0.045,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildInfoCard(
//                 context,
//                 mainText: '${product.caloriesPer100g}',
//                 subText: 'سعرة حرارية',
//                 extraText: 'لكل 100 جرام',
//                 icon: 'assets/images/calories.svg',
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildInfoCard(
//                 context,
//                 mainText: product.expiryName,
//                 subText: '${product.expiryNumber} أيام',
//                 icon: 'assets/images/expiry.svg',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

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

class buildInfoCard extends StatelessWidget {
  const buildInfoCard({
    super.key,
    required this.mainText,
    required this.subText,
    this.extraText,
    required this.iconInfo,
  });

  final String mainText;
  final String subText;
  final String? extraText;
  final Widget iconInfo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? TColors.darkerGrey
                : TColors.borderPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mainText,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: constraints.maxWidth * 0.09,
                          color: TColors.primary,
                        ),
                      ),
                      if (extraText != null)
                        Text(
                          extraText!,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: constraints.maxWidth * 0.07,
                            color: TColors.darkGrey,
                          ),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        subText,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: constraints.maxWidth * 0.07,
                          color: TColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(child: iconInfo),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
