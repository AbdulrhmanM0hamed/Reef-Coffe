import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/product_card.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';

class FavoritesView extends StatelessWidget {
  static const String routeName = 'favorites';

  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<FavoriteCubit>()),
        BlocProvider.value(value: getIt<CartCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'المفضلة',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
            ),
          ),
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoaded) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد منتجات في المفضلة',
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                    ),
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final product = state.favorites[index];
                  return ProductCard(product: product);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
