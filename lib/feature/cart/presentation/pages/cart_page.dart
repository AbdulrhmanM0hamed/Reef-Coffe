import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/widgets/paying_button.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'سلة التسوق',
          style: getBoldStyle(
              fontFamily: FontConstant.cairo, fontSize: FontSize.size20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
                onTap: () => context.read<CartCubit>().clearCart(),
                child: SvgPicture.asset(
                  "assets/images/trash.svg",
                  width: 24,
                  height: 24,
                )),
          )
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cartCubit = context.read<CartCubit>();
          final items = cartCubit.getItems();
          if (items.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'سلة التسوق فارغة',
                    style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size18,
                        color: TColors.darkGrey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    "assets/images/basket.svg",
                    width: 50,
                    height: 50,
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
                padding: const EdgeInsets.all(16),
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
                              fontSize: FontSize.size18,
                              color: TColors.darkGrey),
                        ),
                        Text(
                          '${cartCubit.getTotal()} ج.م',
                          style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.047,
                              color: TColors.secondary),
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
  }
}
