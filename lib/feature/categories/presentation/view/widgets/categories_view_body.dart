import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/errors/network_error_handler.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/feature/categories/presentation/controller/categories_cubit.dart';
import 'package:hyper_market/feature/categories/presentation/controller/categories_state.dart';
import 'package:hyper_market/feature/categories/presentation/view/widgets/category_cart.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_text_field.dart';

class CategoriesViewBodyApp extends StatelessWidget {
  const CategoriesViewBodyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      child: Column(
        children: [
          const CustomSearchTextField(),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoading) {
                  return const Center(child: CircularProgressIndicator(
                    color: TColors.primary,
                  ));
                } else if (state is CategoriesError) {
                  return NetworkErrorHandler.buildErrorWidget(
                    state.message,
                    () => context.read<CategoriesCubit>().getAllCategories(),
                  );
                } else if (state is CategoriesLoaded) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(size),
                      crossAxisSpacing: size.width * 0.02,
                      mainAxisSpacing: size.height * 0.02,
                      childAspectRatio: _getAspectRatio(size),
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return CategoryCart(
                        category: category,
                        colorIndex: index,
                      );
                    },
                  );
                }
                return const Center(child: Text("لا توجد فئات"));
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(Size size) {
    if (size.width < 360) {
      return 1;
    } else if (size.width < 600) {
      return 2;
    } else if (size.width < 900) {
      return 3;
    }
    return 4;
  }

  double _getAspectRatio(Size size) {
    if (size.width < 360) {
      return 1.2;
    } else if (size.width < 600) {
      return 1.5;
    } else if (size.width < 900) {
      return 1.3;
    }
    return 1.4;
  }
}
