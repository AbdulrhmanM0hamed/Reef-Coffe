import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/logo_with_app_name.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/outline.dart';

class OnBoardingViewBody extends StatelessWidget {
  const OnBoardingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeheight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: sizeWidth / 20, vertical: sizeheight / 29),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .53,
            decoration: BoxDecoration(
                border: Border.all(color: TColors.darkGrey),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color.fromARGB(255, 19, 19, 19)
                    : TColors.white,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sizeWidth / 10, vertical: sizeheight / 25),
                  child: const LogoWithAppName(),
                ),
                SizedBox(height: sizeheight / 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeWidth / 10),
                  child: const Column(
                    children: [
                      OutlineWidget(
                        image: AssetsManager.organicFood,
                        title: "منتجات طبيعية",
                      ),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                          image: AssetsManager.foodTurkey,
                          title: "الأطعمة الكاملة والخضروات"),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                        image: AssetsManager.deliveryTruck,
                        title: " تسليم سريع",
                      ),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                        image: AssetsManager.solarMoney,
                        title: " الإسترجاع والإسترداد",
                      ),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                        image: AssetsManager.safeLock,
                        title: " سليم وآمن",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: sizeheight / 20,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "مرحبا بك فى ", // النص الأول
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size22,
                      color: TColors.primary),
                ),
                TextSpan(
                  text: "هايير", // النص الأول
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size22,
                      color: TColors.primary),
                ),
                TextSpan(
                  text: "  ماركت", // النص الثاني
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size22,
                      color: TColors.secondary),
                ),
              ],
            ),
          ),
          SizedBox(
            height: sizeheight / 100,
          ),
          Text(
            "اكتشف تجربة تسوق فريدة مع هايبر ماركت , استكشف مجموعتنا الواسعة من الفواكه الطازجة الممتازة واحصل على افضل العروض والجودة العالية",
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: TColors.darkGrey),
          ),
          SizedBox(
            height: sizeheight / 15,
          ),
          CustomElevatedButton(
            buttonText: "ابدأ الان",
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
