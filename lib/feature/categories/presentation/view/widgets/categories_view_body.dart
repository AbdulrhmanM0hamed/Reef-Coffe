import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/categories/presentation/cubit/categories_cubit.dart';
import 'package:hyper_market/feature/categories/presentation/cubit/categories_state.dart';
import 'package:hyper_market/feature/categories/presentation/view/widgets/category_cart.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/custom_text_field.dart';

class CategoriesViewBodyApp extends StatelessWidget {
  const CategoriesViewBodyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          const CustomSearchTextField(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoriesError) {
                  return Center(child: Text(state.message));
                } else if (state is CategoriesLoaded) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.5,
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
                return const Center(child: Text("لا توجد فئات"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
