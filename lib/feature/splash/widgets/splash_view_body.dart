import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/on_bordaing_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.65, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
    excuteNavigation(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetsManager.logo,
                      height: 100,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "ريف القهوة",
                          style: getBoldStyle(
                              fontFamily: FontConstant.almarai,
                              fontSize: FontSize.size24,
                              color: TColors.primary),
                        ),
                        Text(
                          "لتقديم الوجبات",
                          style: getBoldStyle(
                            fontFamily: FontConstant.almarai,
                            fontSize: FontSize.size16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.white
                                    : TColors.darkerGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void excuteNavigation(BuildContext context) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, OnBordaingView.routeName);
    } catch (e) {
      debugPrint('Error in navigation: $e');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, OnBordaingView.routeName);
    }
  }
}
