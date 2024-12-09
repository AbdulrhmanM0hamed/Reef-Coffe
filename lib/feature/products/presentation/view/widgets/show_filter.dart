  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/product_filter_sheet.dart';

void showFilterSheet(BuildContext context) {
    final productsCubit = context.read<ProductsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocProvider.value(
        value: productsCubit,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ProductFilterSheet(
            onApplyFilter: (minPrice, maxPrice, isNatural, hasDiscount) {
              productsCubit.filterProducts(
                minPrice: minPrice,
                maxPrice: maxPrice,
                isNatural: isNatural,
                hasDiscount: hasDiscount,
              );
            },
          ),
        ),
      ),
    );
  }
