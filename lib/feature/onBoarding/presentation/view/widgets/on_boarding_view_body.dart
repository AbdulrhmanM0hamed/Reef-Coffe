import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/strings_manager.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/logo_with_app_name.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/outline.dart';

class OnBoardingViewBody extends StatelessWidget {
  const OnBoardingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.035),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.53,
            decoration: BoxDecoration(
                border: Border.all(color: TColors.darkGrey),
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 19, 19, 19)
                    : TColors.white,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: size.height * 0.04),
                  child: const LogoWithAppName(),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: const Column(
                    children: [
                      OutlineWidget(
                        image: AssetsManager.organicFood,
                        title: StringManager.organicFood,
                      ),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                          image: AssetsManager.foodTurkey,
                          title: StringManager.fullFoods),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                        image: AssetsManager.deliveryTruck,
                        title: StringManager.deliveryTruck,
                      ),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                        image: AssetsManager.solarMoney,
                        title: StringManager.refund,
                      ),
                      Divider(
                        indent: 10,
                      ),
                      OutlineWidget(
                        image: AssetsManager.safeLock,
                        title: StringManager.safe,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: StringManager.welcome, // النص الأول
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: size.height * 0.025,
                      color: TColors.primary),
                ),
                TextSpan(
                  text: StringManager.hyper, // النص الأول
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: size.height * 0.025,
                      color: TColors.primary),
                ),
                TextSpan(
                  text: StringManager.market, // النص الثاني
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: size.height * 0.025,
                      color: TColors.secondary),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            StringManager.supTitleFOrWelcom,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: size.height * 0.016,
                color: TColors.darkGrey),
          ),
          SizedBox(
            height: size.height * 0.06,
          ),
          CustomElevatedButton(
            buttonText: StringManager.start,
            onPressed: () {
              Navigator.pushReplacementNamed(context, SigninView.routeName);
            },
          )
        ],
      ),
    );
  }
}
