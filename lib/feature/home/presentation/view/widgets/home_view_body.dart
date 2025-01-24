import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
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
import 'package:hyper_market/feature/products/presentation/cubit/products_state.dart';

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

  @override
  void initState() {
    super.initState();
    _productsCubit = ProductsCubit(getIt<ProductRepository>());
    _productsCubit.getAllProducts();
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
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: TColors.primary),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      CustomHomeAppBar(userName: widget.userName),
                      const SizedBox(height: 20),
                      const CustomSearchTextField(),
                      const SizedBox(height: 20),
                      HomeTopSlider(),
                      const SizedBox(height: 4),
                      OutLineOfProducts(
                        title: "عروض حصرية",
                        onSeeMorePressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExclusiveOffersPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const ExclusiveOfferSection(),
                      const SizedBox(height: 16),
                      OutLineOfProducts(
                        title: "المكملات الغذائية",
                        onSeeMorePressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SupplementsPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const SupplementsSection(),
                      const SizedBox(height: 16),
                      OutLineOfProducts(
                        title: "الأكثر طلباً",
                        onSeeMorePressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BestSellingPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const BestSellingProductsListView(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
