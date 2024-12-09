import 'package:flutter/material.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/auth/presentation/view/signup_view.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';
import 'package:hyper_market/feature/home/presentation/view/home_view.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/on_bordaing_view.dart';
import 'package:hyper_market/feature/splash/view/splash_view.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  if (settings.name == DetailsView.routeName) {
    final product = settings.arguments as Product;
    return MaterialPageRoute(
      builder: (context) => DetailsView(product: product),
    );
  }

  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
    case OnBordaingView.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnBordaingView(),
      );
    case SigninView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SigninView(),
      );
    case SignupView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignupView(),
      );
    case HomeView.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
  }
}
