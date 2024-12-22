import 'package:flutter/material.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/strings_manager.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/logo_with_app_name.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/outline.dart';
import 'package:hyper_market/core/utils/animations/custom_animations.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.035),
      child: Column(
        children: [
          CustomAnimations.slideFromLeft(
            duration: Duration(milliseconds: 800),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 800),
              opacity: _isVisible ? 1.0 : 0.0,
              child: Container(
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
                          horizontal: size.width * 0.1,
                          vertical: size.height * 0.04),
                      child: CustomAnimations.fadeIn(
                        duration: Duration(milliseconds: 1000),
                        child: const LogoWithAppName(),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.1),
                      child: Column(
                        children: [
                          CustomAnimations.slideFromLeft(
                            duration: Duration(milliseconds: 800),
                            child: const OutlineWidget(
                              image: AssetsManager.organicFood,
                              title: 'وجبات صحية',
                            ),
                          ),
                          Divider(
                            indent: 10,
                          ),
                          CustomAnimations.slideFromLeft(
                            duration: Duration(milliseconds: 900),
                            child: const OutlineWidget(
                              image: AssetsManager.foodTurkey,
                              title: StringManager.fullFoods,
                            ),
                          ),
                          Divider(
                            indent: 10,
                          ),
                          CustomAnimations.slideFromLeft(
                            duration: Duration(milliseconds: 1000),
                            child: const OutlineWidget(
                              image: AssetsManager.deliveryTruck,
                              title: StringManager.deliveryTruck,
                            ),
                          ),
                          Divider(
                            indent: 10,
                          ),
                          CustomAnimations.slideFromLeft(
                            duration: Duration(milliseconds: 1100),
                            child: const OutlineWidget(
                              image: AssetsManager.solarMoney,
                              title: StringManager.refund,
                            ),
                          ),
                          Divider(
                            indent: 10,
                          ),
                          CustomAnimations.slideFromLeft(
                            duration: Duration(milliseconds: 1200),
                            child: const OutlineWidget(
                              image: AssetsManager.safeLock,
                              title: StringManager.safe,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          CustomAnimations.fadeIn(
            duration: Duration(milliseconds: 1300),
            child: RichText(
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
                    text: 'ريف ' , // النص الأول
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: size.height * 0.025,
                        color: TColors.primary),
                  ),
                  TextSpan(
                    text: 'القهوة', // النص الثاني
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: size.height * 0.025,
                        color: TColors.secondary),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          CustomAnimations.fadeIn(
            duration: Duration(milliseconds: 1400),
            child: Text(
              StringManager.supTitleFOrWelcom,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: size.height * 0.016,
                  color: TColors.darkGrey),
            ),
          ),
          SizedBox(
            height: size.height * 0.06,
          ),
          CustomAnimations.fadeIn(
            duration: Duration(milliseconds: 1500),
            child: CustomElevatedButton(
              buttonText: StringManager.start,
              onPressed: ()  {
                Prefs.setBool(KIsOnboardingViewSeen, true);
                Navigator.pushReplacementNamed(context, SigninView.routeName);
              },
            ),
          )
        ],
      ),
    );
  }
}
