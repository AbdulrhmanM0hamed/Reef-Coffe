import 'package:flutter/material.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/core/utils/constants/strings_manager.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/home/presentation/view/home_view.dart';
import 'package:hyper_market/core/utils/animations/custom_animations.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // صورة الخلفية
          Image.asset(
            'assets/images/on_boarding_p.png', // تأكد من وجود الصورة
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          
          // طبقة التعتيم
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // الزر
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
              child: CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1500),
                child: CustomElevatedButton(
                  buttonText: StringManager.start,
                  onPressed: () async {
                    final isLoginSuccess = Prefs.getBool(KIsloginSuccess);
                    final isUserLogout = Prefs.getBool(KUserLogout);

                    if (isLoginSuccess == true && isUserLogout != true) {
                      Navigator.pushReplacementNamed(context, HomeView.routeName);
                    } else {
                      Navigator.pushReplacementNamed(context, SigninView.routeName);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
