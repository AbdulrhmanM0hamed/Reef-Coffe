import 'package:flutter/material.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/on_boarding_view_body.dart';

class OnBordaingView extends StatelessWidget {
  const OnBordaingView({super.key});

  static const String routeName = 'onBoardingView';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: OnBoardingViewBody(),
    );
  }
}
