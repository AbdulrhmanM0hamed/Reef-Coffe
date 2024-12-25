import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/errors/network_error_handler.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_state.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/product_card.dart';

class BestSellingPage extends StatelessWidget {
  const BestSellingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'الأكثر طلباً'),
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
              final bestSellingProducts = state.products
                  .where((product) => product.soldCount > 10)
                  .toList();

              if (bestSellingProducts.isEmpty) {
                return const Center(
                  child: Text('لا توجد منتجات مباعة'),
                );
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
                  itemCount: bestSellingProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: bestSellingProducts[index],
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
