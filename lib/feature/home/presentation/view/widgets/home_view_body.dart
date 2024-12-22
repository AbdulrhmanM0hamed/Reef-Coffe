import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/animations/custom_animations.dart';
import 'package:hyper_market/feature/home/presentation/cubit/special_offers_cubit.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/best_selling_products_list_view.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_home_app_bar.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_text_field.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/exclusive_offer_list_view%20.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/home_top_slider.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/outline_of_products.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';

class HomeViewBody extends StatefulWidget {
  final String userName;
  HomeViewBody({super.key, required this.userName});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomAnimations.fadeIn(
              duration: const Duration(milliseconds: 800),
              child: CustomHomeAppBar(userName: widget.userName),
            ),
            const SizedBox(height: 20),
            CustomAnimations.slideFromTop(
              duration: const Duration(milliseconds: 900),
              child: const CustomSearchTextField(),
            ),
            const SizedBox(height: 20),
            CustomAnimations.slideFromTop(
              duration: const Duration(milliseconds: 1000),
              child: BlocProvider(
                create: (context) =>
                    getIt<SpecialOffersCubit>()..loadSpecialOffers(),
                child: HomeTopSlider(),
              ),
            ),
            const SizedBox(height: 4),
            CustomAnimations.slideFromTop(
              duration: const Duration(milliseconds: 1100),
              child: const OutLineOfProducts(title: "عروض حصرية"),
            ),
            const SizedBox(height: 16),
            CustomAnimations.slideFromRight(
              duration: const Duration(milliseconds: 1200),
              child: ExclusiveOfferSection(),
            ),
            const SizedBox(height: 16),
            CustomAnimations.slideFromLeft(
              duration: const Duration(milliseconds: 1300),
              child: const OutLineOfProducts(title: "الأكثر مبيعا"),
            ),
            const SizedBox(height: 16),
            CustomAnimations.slideFromRight(
              duration: const Duration(milliseconds: 1400),
              child: BestSellingProductsListView(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
