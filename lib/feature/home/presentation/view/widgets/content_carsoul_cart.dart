import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class ContentOfCarsoulCart extends StatelessWidget {
  const ContentOfCarsoulCart({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -size.height * 0.05,
          left: -size.width * 0.05,
          child: Image.asset(
            'assets/images/fr1.png',
            width: size.width * 0.2,
            height: size.height * 0.15,
          ),
        ),
        Positioned(
          bottom: -size.height * 0.06,
          right: -size.width * 0.05,
          child: Image.asset(
            'assets/images/trea.png',
            width: size.width * 0.2,
            height: size.height * 0.15,
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                child: Image.asset(
                  'assets/images/ana.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "عروض خاصة",
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size18,
                      color: TColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "تخفيضات تصل حتى 50%",
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

