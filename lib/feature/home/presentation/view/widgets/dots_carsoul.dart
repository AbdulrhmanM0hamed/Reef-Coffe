import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DotOfCorsoul extends StatelessWidget {
  const DotOfCorsoul({
    super.key,
    required ValueNotifier<int> currentPageNotifier,
    required this.size,
  }) : _currentPageNotifier = currentPageNotifier;

  final ValueNotifier<int> _currentPageNotifier;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentPageNotifier,
      builder: (context, currentPage, child) {
        return Padding(
          padding: EdgeInsets.only(top: size.height * 0.01),
          child: SmoothPageIndicator(
            controller: PageController(initialPage: currentPage),
            count: 3,
            effect: const WormEffect(
              activeDotColor: TColors.secondary,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
        );
      },
    );
  }
}
