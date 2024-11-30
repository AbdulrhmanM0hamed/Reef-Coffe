import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeTopSlider extends StatelessWidget {
  HomeTopSlider({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  // دالة لتوليد تدرج ألوان بسيطة ولكنها أكثر جاذبية
  List<Color> generateSimpleGradient() {
    final random = Random();
    return [
      Color.fromARGB(
        255,
        200 + random.nextInt(56),
        200 + random.nextInt(56),
        200 + random.nextInt(56),
      ), // لون فاتح بسيط ولكنه أكثر جاذبية
      Color.fromARGB(
        255,
        180 + random.nextInt(56),
        180 + random.nextInt(56),
        180 + random.nextInt(56),
      ), // لون أهدأ ولكنه أكثر جاذبية
    ];
  }

  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: sizeHeight * 0.2, // ارتفاع السلايدر
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final gradient = generateSimpleGradient();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // صورة في الأعلى على اليسار
                      Positioned(
                        top: -35,
                        left: -25,
                        child: Image.asset(
                          'assets/images/fr1.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                      // صورة في الأسفل على اليمين
                      Positioned(
                        bottom: -42,
                        right: -25,
                        child: Image.asset(
                          'assets/images/trea.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Image.asset(
                                'assets/images/Apple.png'  ,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "عروض خاصة",
                                  style: getBoldStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "تخفيضات تصل حتى 50%",
                                  style: getBoldStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size16,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: 3,
                            effect: const WormEffect(
                              activeDotColor: Colors.green,
                              dotHeight: 8,
                              dotWidth: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
