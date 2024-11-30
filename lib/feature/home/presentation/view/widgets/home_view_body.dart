import 'package:flutter/material.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/best_selling_products_list_view.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_home_app_bar.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_text_field.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/exclusive_offer_list_view%20.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/home_top_slider.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/outline_of_products.dart';

class HomeViewBody extends StatelessWidget {
  HomeViewBody({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
          const  CustomHomeAppBar(),
          const  SizedBox(
              height: 20,
            ),
        const CustomSearchTextField(),
          const  SizedBox(
              height: 20,
            ),
            HomeTopSlider(),
            const  SizedBox(
              height: 4,
            ),
           const OutLineOfProducts(
               title: "عروض حصرية"
            ),
            const  SizedBox(
              height: 16,
            ),
            ExclusiveOfferSection() ,
             const OutLineOfProducts(
               title: "الأكثر مبيعا"
            ),
            const  SizedBox(
              height: 16,
            ),
            BestSellingProductsListView()
          ],
        ),
      ),
    );
  }
}
