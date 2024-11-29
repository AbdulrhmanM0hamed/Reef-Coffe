import 'package:flutter/material.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/on_bordaing_view.dart';
import 'package:hyper_market/feature/splash/view/splash_view.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  // Define the route based on the settings name

  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
    case OnBordaingView.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnBordaingView(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
  }
}
