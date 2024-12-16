import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/categories/domain/entities/category.dart';
import '../cubit/products_cubit.dart';
import 'widgets/products_view_body.dart';

class ProductsView extends StatelessWidget {
  final Category category;

  const ProductsView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsCubit(getIt())..getProductsByCategory(category.id),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            category.name,
            style: getBoldStyle(
                fontFamily: FontConstant.cairo, fontSize: FontSize.size20),
          ),
        ),
        body: const ProductsViewBody(),
      ),
    );
  }
}
