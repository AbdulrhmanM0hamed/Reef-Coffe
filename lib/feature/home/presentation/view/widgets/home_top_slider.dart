import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:hyper_market/feature/home/presentation/view/widgets/content_carsoul_cart.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/dots_carsoul.dart';

class HomeTopSlider extends StatefulWidget {
  HomeTopSlider({Key? key}) : super(key: key);

  @override
  _HomeTopSliderState createState() => _HomeTopSliderState();
}

class _HomeTopSliderState extends State<HomeTopSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  // دالة لتوليد تدرج ألوان بسيطة ولكنها أكثر جاذبية
  List<Color> generateSimpleGradient() {
    final random = Random();
    return [
      Color.fromARGB(
        255,
        200 + random.nextInt(56),
        200 + random.nextInt(56),
        200 + random.nextInt(56),
      ),
      Color.fromARGB(
        255,
        180 + random.nextInt(56),
        180 + random.nextInt(56),
        180 + random.nextInt(56),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: size.height * 0.18,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 900),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1.02,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              _currentPageNotifier.value = index; // تحديث الصفحة الحالية
            },
          ),
          itemCount: 3,
          itemBuilder: (context, index, realIndex) {
            final gradient = generateSimpleGradient();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                child: ContentOfCarsoulCart(size: size),
              ),
            );
          },
        ),
        DotOfCorsoul(currentPageNotifier: _currentPageNotifier, size: size),
      ],
    );
  }
}
