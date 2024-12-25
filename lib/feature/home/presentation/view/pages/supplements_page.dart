import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/errors/network_error_handler.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_state.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/product_card.dart';

class SupplementsPage extends StatelessWidget {
  const SupplementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'المكملات الغذائية'),
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
              final supplements = state.products
                  .where((product) =>
                      product.categoryId ==
                      'd2f39e30-74ad-43f2-a5c5-ff9bf518b351')
                  .toList();

              if (supplements.isEmpty) {
                return const Center(
                    child: Text('لا توجد مكملات غذائية متوفرة'));
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
                  itemCount: supplements.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: supplements[index],
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
