import 'package:flutter/material.dart';
import 'package:hyper_market/feature/splash/widgets/splash_view_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const String routeName = 'splash';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child: SplashViewBody())
    ) ;
  }
}