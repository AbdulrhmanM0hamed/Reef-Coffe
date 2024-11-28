import 'package:flutter/material.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) 
{
  // Define the route based on the settings name

  switch (settings.name) {
 
    case SplashView.routeName:
    return MaterialPageRoute(
      builder: (context) => const SplashView(),
    );
     case OnBoardingView.routeName:
      return MaterialPageRoute(
      builder: (context) => const OnBoardingView(),
    );
     case SigninView.routeName:
      return MaterialPageRoute(
      builder: (context) => const SigninView(),
    );
    case SignupView.routeName:
    return MaterialPageRoute(
      builder: (context) => const SignupView(),
    );
    case ForgotPasswordView.routeName:
    return MaterialPageRoute(
      builder: (context) => const ForgotPasswordView(),
    );
     case VerificationCodeView.routeName:
    return MaterialPageRoute(
      builder: (context) => const VerificationCodeView(),
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