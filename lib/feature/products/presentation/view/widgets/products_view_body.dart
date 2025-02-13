import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/errors/network_error_handler.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/show_filter.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/text_filed_productview.dart';
import '../../cubit/products_cubit.dart';
import '../../cubit/products_state.dart';
import 'product_card.dart';

class ProductsViewBody extends StatelessWidget {
  const ProductsViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        // Handle cart state changes if needed
      },
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsError) {
            return NetworkErrorHandler.buildErrorWidget(
              state.message,
              () => context.read<ProductsCubit>().getAllProducts(),
            );
          } else if (state is ProductsLoaded) {
            return Column(
              children: [
                // Search and Filter Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: CustomTextFieldProductsView(),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.darkGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => showFilterSheet(context),
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Products Grid or Empty State
                Expanded(
                  child: state.products.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد منتجات',
                            style: getRegularStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: state.products[index]);
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
