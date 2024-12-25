import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/errors/network_error_handler.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_state.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/product_card.dart';

class ExclusiveOffersPage extends StatelessWidget {
  const ExclusiveOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'العروض الحصرية'),
      body: BlocProvider(
        create: (context) => getIt<ProductsCubit>()..getAllProducts(),
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsError) {
              return NetworkErrorHandler.buildErrorWidget(
                state.message,
                () => context.read<ProductsCubit>().getAllProducts(),
              );
            } else if (state is ProductsLoaded) {
              final discountedProducts = state.products
                  .where((product) =>
                      product.hasDiscount &&
                      (product.discountPrice ?? 0) > 0 &&
                      product.categoryId !=
                          'd2f39e30-74ad-43f2-a5c5-ff9bf518b351')
                  .toList();

              if (discountedProducts.isEmpty) {
                return const Center(child: Text('لا توجد عروض حالياً'));
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: discountedProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: discountedProducts[index],
                    );
                  },
                ),
              );
            }
            // Loading state
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
