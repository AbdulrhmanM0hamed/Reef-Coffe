import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/widgets/paying_button.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  static const String routeName = 'cart_page';

  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return baseSize * 1.2;
    } else if (width >= 768) {
      return baseSize * 1.1;
    } else if (width >= 390) {
      return baseSize;
    } else {
      return baseSize * 0.9;
    }
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return baseSpacing * 1.5;
    } else if (width >= 768) {
      return baseSpacing * 1.25;
    } else if (width >= 390) {
      return baseSpacing;
    } else {
      return baseSpacing * 0.75;
    }
  }

  double _getResponsiveIconSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return baseSize * 1.3;
    } else if (width >= 768) {
      return baseSize * 1.2;
    } else if (width >= 390) {
      return baseSize;
    } else {
      return baseSize * 0.8;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final items = state is CartUpdated 
            ? state.items 
            : context.read<CartCubit>().getItems();

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'سلة التسوق',
              style: getBoldStyle(
                  fontFamily: FontConstant.cairo, 
                  fontSize: _getResponsiveFontSize(context, FontSize.size20)),
            ),
            actions: items.isNotEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                          onTap: () => context.read<CartCubit>().clearCart(),
                          child: SvgPicture.asset(
                            "assets/images/trash.svg",
                            width: _getResponsiveIconSize(context, 24),
                            height: _getResponsiveIconSize(context, 24),
                          )),
                    )
                  ]
                : null,
          ),
          body: BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartUpdated) {
              }
            },
            builder: (context, state) {
              // Get items directly from state if available
              final items = state is CartUpdated 
                  ? state.items 
                  : context.read<CartCubit>().getItems();
              
              if (items.isEmpty) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'سلة التسوق فارغة',
                        style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: _getResponsiveFontSize(context, FontSize.size18),
                            color: TColors.darkGrey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                        "assets/images/basket.svg",
                        width: _getResponsiveIconSize(context, 50),
                        height: _getResponsiveIconSize(context, 50),
                      )
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                          item: items[index],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(_getResponsiveSpacing(context, 16)),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.darkerGrey.withOpacity(.20),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'المجموع',
                              style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: _getResponsiveFontSize(context, FontSize.size20),
                                  color: TColors.primary),
                            ),
                            Text(
                              '${context.read<CartCubit>().getTotal()} ريال',
                              style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.047,
                                  ),
                            ),
                          ],
                        ),
                        const PayingButton(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
