import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/utils/constants/strings_manager.dart';
import 'package:hyper_market/feature/categories/presentation/controller/categories_cubit.dart';
import 'package:hyper_market/feature/categories/presentation/view/widgets/categories_view_body.dart';

class CategoriesViewApp extends StatelessWidget {
  const CategoriesViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(getIt())..getAllCategories(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            StringManager.products,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
            ),
          ),
        ),
        body: const CategoriesViewBodyApp(),
      ),
    );
  }
}
