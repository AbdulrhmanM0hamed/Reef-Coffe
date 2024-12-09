import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_state.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/product_card.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/product_card_shimmer.dart';

class ExclusiveOfferSection extends StatelessWidget {
  const ExclusiveOfferSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(getIt())..getAllProducts(),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsError) {
            return Center(child: Text(state.message));
          } else if (state is ProductsLoaded) {
            final discountedProducts = state.products
                .where((product) => product.discountPrice! > 0)
                .toList();

            if (discountedProducts.isEmpty) {
              return const Center(child: Text('لا توجد عروض حالياً'));
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: discountedProducts.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ProductCard(
                        product: discountedProducts[index],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          // Loading state
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // عدد العناصر في حالة التحميل
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: ProductCardShimmer(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
