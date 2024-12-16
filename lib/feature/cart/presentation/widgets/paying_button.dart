import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/cart/presentation/widgets/checkout_bottom_sheet.dart';
import 'package:hyper_market/feature/home/presentation/view/home_view.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_cubit.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_state.dart';

class PayingButton extends StatelessWidget {
  const PayingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartItems = context.read<CartCubit>().getItems();
        final totalAmount = context.read<CartCubit>().getTotal();

        return ElevatedButton(
          onPressed: cartItems.isEmpty
              ? null
              : () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: getIt<OrdersCubit>(),
                        ),
                        BlocProvider.value(
                          value: getIt<CartCubit>(),
                        ),
                      ],
                      child: BlocListener<OrdersCubit, OrdersState>(
                        listener: (context, state) {
                          if (state is OrderCreated) {
                            context.read<CartCubit>().clearCart();
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, HomeView.routeName  );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم اضافة الطلب بنجاح'),
                                duration: Duration(seconds: 2),
                                backgroundColor: TColors.primary,
                              ),
                            );
                          } else if (state is OrderCreationError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        child: CheckoutBottomSheet(
                          cartItems: cartItems,
                          totalAmount: totalAmount,
                        ),
                      ),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: TColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
          child:  Text(
            'اتمام الشراء',
            style: getBoldStyle(fontFamily: FontConstant.cairo, fontSize: 16),
          ),
        );
      },
    );
  }
}
