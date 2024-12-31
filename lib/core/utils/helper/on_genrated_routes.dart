import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/auth/presentation/view/forget_password.dart';
import 'package:hyper_market/feature/auth/presentation/view/new_password_view.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/auth/presentation/view/signup_view.dart';
import 'package:hyper_market/feature/auth/presentation/view/verification_code_view.dart';
import 'package:hyper_market/feature/cart/presentation/pages/cart_page.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';
import 'package:hyper_market/feature/details/presentation/view/product_reviewss_view.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/favorites/presentation/view/favorites_view.dart';
import 'package:hyper_market/feature/home/presentation/view/home_view.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/on_bordaing_view.dart';
import 'package:hyper_market/feature/orders/presentation/view/orders_view.dart';
import 'package:hyper_market/feature/splash/view/splash_view.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  if (settings.name == DetailsView.routeName) {
    final product = settings.arguments as Product;
    return MaterialPageRoute(
      builder: (context) => DetailsView(product: product , heroTag: 'details'),
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
    case ForgotPasswordView.routeName:
      return MaterialPageRoute(
        builder: (context) => const ForgotPasswordView(),
      );
    case OrdersView.routeName:
      return MaterialPageRoute(
        builder: (context) => const OrdersView(),
      );
    case VerificationCodeView.routeName:
      final email = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => VerificationCodeView(email: email),
      );
    case NewPasswordView.routeName:
      final email = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => NewPasswordView(email: email),
      );
    case FavoritesView.routeName:
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: getIt<FavoriteCubit>(),
          child: const FavoritesView(),
        ),
      );
    case ProductReviewsView.routeName:
      final productId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ProductReviewsView(productId: productId),
      );
    case CartPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const CartPage(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
  }
}
