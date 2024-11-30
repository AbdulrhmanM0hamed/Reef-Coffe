import 'package:flutter/material.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_home_app_bar.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/promotion_banner.dart';

class HomeViewBody extends StatelessWidget {
   HomeViewBody({super.key});
final List<Map<String, String>> promotions = [
    {
      'imageUrl': 'assets/images/firstpic.png',
      'title': 'Fresh Vegetables',
      'subtitle': 'Get Up To 40% OFF',
    },
 
  ];
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        CustomHomeAppBar(),
        SizedBox(
          height: 20,
        ),
        HomeTopSlider(),
      ],

    );
  }
}