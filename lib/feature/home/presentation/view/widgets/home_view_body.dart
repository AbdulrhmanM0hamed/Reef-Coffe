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
import 'package:hyper_market/feature/home/presentation/view/widgets/supplements_section.dart';
import 'package:hyper_market/feature/products/domain/repositories/product_repository.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/home/presentation/view/pages/exclusive_offers_page.dart';
import 'package:hyper_market/feature/home/presentation/view/pages/supplements_page.dart';
import 'package:hyper_market/feature/home/presentation/view/pages/best_selling_page.dart';

class HomeViewBody extends StatefulWidget {
  final String userName;

  const HomeViewBody({
    super.key,
    required this.userName,
  });

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late final ProductsCubit _productsCubit;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _productsCubit = ProductsCubit(getIt<ProductRepository>());
    _productsCubit.getAllProducts();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _productsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SpecialOffersCubit>()..loadSpecialOffers(),
        ),
        BlocProvider.value(
          value: _productsCubit,
        ),
      ],
      child: Padding(
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
                child: HomeTopSlider(),
              ),
              const SizedBox(height: 4),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1100),
                child: OutLineOfProducts(
                  title: "عروض حصرية",
                  onSeeMorePressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const ExclusiveOffersPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomAnimations.slideFromRight(
                duration: const Duration(milliseconds: 1200),
                child:const ExclusiveOfferSection(),
              ),
              const SizedBox(height: 16),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1300),
                child: OutLineOfProducts(
                  title: "المكملات الغذائية",
                  onSeeMorePressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const SupplementsPage(),
                       
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomAnimations.slideFromRight(
                duration: const Duration(milliseconds: 1400),
                child: const SupplementsSection(),
              ),
              const SizedBox(height: 16),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1500),
                child: OutLineOfProducts(
                  title: "الأكثر طلباً",
                  onSeeMorePressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const BestSellingPage(),
                      
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomAnimations.slideFromRight(
                duration: const Duration(milliseconds: 1600),
                child: const BestSellingProductsListView(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
