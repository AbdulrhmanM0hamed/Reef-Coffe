import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/categories/categories_view.dart';
import 'package:hyper_market/feature/dashboard/presentation/view_model/categories/categories_cubit.dart';
import 'package:hyper_market/feature/dashboard/presentation/view_model/products/products_cubit.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/products/products_view.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/widgets/side_menu.dart';

class DashboardViewBody extends StatefulWidget {
  final int selectedIndex;

  const DashboardViewBody({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<DashboardViewBody> createState() => _DashboardViewBodyState();
}

class _DashboardViewBodyState extends State<DashboardViewBody> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SideMenu(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                MultiBlocProvider(
                  providers: [
                    BlocProvider<CategoriesCubit>(
                      create: (context) => CategoriesCubit()..loadCategories(),
                    ),
                    BlocProvider<ProductsCubit>(
                      create: (context) => ProductsCubit()..loadProducts(),
                    ),
                  ],
                  child: const ProductsView(),
                ),
                const Center(child: Text('المنتجات')),
                BlocProvider(
                  create: (context) => CategoriesCubit()..loadCategories(),
                  child: const CategoriesView(),
                ),
                const Center(child: Text('الطلبات')),
                const Center(child: Text('المستخدمين')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
