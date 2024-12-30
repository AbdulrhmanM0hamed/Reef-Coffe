import 'package:flutter/material.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/assets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/utils/constants/strings_manager.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/home/presentation/view/home_view.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/logo_with_app_name.dart';
import 'package:hyper_market/feature/onBoarding/presentation/view/widgets/outline.dart';
import 'package:hyper_market/core/utils/animations/custom_animations.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideo();
    });
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/images/onboarding_video.mp4',
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      await _videoController.initialize();

      if (mounted) {
        // تعيين أقصى جودة متاحة
        _videoController.setPlaybackSpeed(1.0);
        _videoController.setVolume(1.0);

        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.setLooping(true);
        _videoController.play();
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_isVideoInitialized) {
      _videoController.dispose(); // تنظيف الذاكرة عند الخروج من الشاشة
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isVideoInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          // طبقة فوق الفيديو
          Container(
            color: Colors.black.withOpacity(0.3), // طبقة شفافة فوق الفيديو
          ),

          // الزر فقط
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
                child: CustomAnimations.fadeIn(
                  duration: Duration(milliseconds: 1500),
                  child: CustomElevatedButton(
                    buttonText: StringManager.start,
                    onPressed: () async {
                      final isLoginSuccess =
                          await Prefs.getBool(KIsloginSuccess);
                      final isUserLogout = await Prefs.getBool(KUserLogout);

                      if (isLoginSuccess == true && isUserLogout != true) {
                        Navigator.pushReplacementNamed(
                            context, HomeView.routeName);
                      } else {
                        Navigator.pushReplacementNamed(
                            context, SigninView.routeName);
                      }
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
