import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';

class CustomTextFieldProductsView extends StatelessWidget {
  const CustomTextFieldProductsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) {
        context.read<ProductsCubit>().searchProducts(query);
      },
      style: getRegularStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size14,
      ),
      decoration: InputDecoration(
        hintText: "ابحث عن المنتج الذي تريده",
        hintStyle: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size14,
         
        ),
        prefixIcon: SizedBox(
          width: 25,
          child: Center(
            child: SvgPicture.asset(
              "assets/images/search_icon.svg",
              width: 27,
            ),
          ),
        ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: TColors.primary,
          ),
        ),
      ),
    );
  }
}