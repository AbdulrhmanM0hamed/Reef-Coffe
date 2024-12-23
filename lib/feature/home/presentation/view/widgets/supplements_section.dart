import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/error/network_error_handler.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/supplements_product_card.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/supplements_product_card_shimmer.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_state.dart';

class SupplementsSection extends StatelessWidget {
  const SupplementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsError) {
            return NetworkErrorHandler.buildErrorWidget(
              state.message,
              () => context.read<ProductsCubit>().getAllProducts(),
              
            );
          } else if (state is ProductsLoaded) {
            final supplements = state.products
                .where((product) => product.categoryId == 'd2f39e30-74ad-43f2-a5c5-ff9bf518b351')
                .toList();

            if (supplements.isEmpty) {
              return const Center(
                child: Text('لا توجد مكملات غذائية متوفرة'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: supplements.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SupplementProductCard(
                    product: supplements[index],
                  ),
                );
              },
            );
          }
          // Show shimmer loading
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SupplementProductCardShimmer(),
              );
            },
          );
        },
    ),
    );
  }
}
