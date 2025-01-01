import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/cart/presentation/widgets/checkout_bottom_sheet.dart';
import 'package:hyper_market/feature/home/presentation/view/home_view.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_cubit.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_state.dart';
import 'package:hyper_market/core/errors/network_error_handler.dart';

class PayingButton extends StatelessWidget {
  const PayingButton({super.key});

  double _getResponsiveSize(BuildContext context, double baseSize) {
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

  double _getResponsivePadding(BuildContext context, double basePadding) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return basePadding * 1.5;
    } else if (width >= 768) {
      return basePadding * 1.25;
    } else if (width >= 390) {
      return basePadding;
    } else {
      return basePadding * 0.75;
    }
  }

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
                            Navigator.pushReplacementNamed(
                                context, HomeView.routeName);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                final size = MediaQuery.of(context).size;
                                final isPortrait = size.height > size.width;
                                final dialogWidth = size.width * (isPortrait ? 0.85 : 0.5);
                                final imageSize = size.width * (isPortrait ? 0.25 : 0.15);
                                
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.of(context).pop();
                                });
                                
                                return Dialog(
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[900]
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Container(
                                    width: dialogWidth,
                                    constraints: BoxConstraints(
                                      maxWidth: 400,
                                      minHeight: size.height * 0.25,
                                    ),
                                    padding: EdgeInsets.all(size.width * 0.05),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: TColors.primary.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(size.width * 0.03),
                                          child: SvgPicture.asset(
                                            'assets/images/order_request.svg',
                                            width: imageSize,
                                            height: imageSize,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.02),
                                        Text(
                                          'تم اضافة الطلب بنجاح',
                                          textAlign: TextAlign.center,
                                          style: getBoldStyle(
                                            fontFamily: FontConstant.cairo,
                                            fontSize: isPortrait 
                                                ? FontSize.size16 
                                                : FontSize.size18,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Text(
                                          'شكراً لك على الطلب',
                                          textAlign: TextAlign.center,
                                          style: getMediumStyle(
                                            fontFamily: FontConstant.cairo,
                                            fontSize: isPortrait 
                                                ? FontSize.size14 
                                                : FontSize.size16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (state is OrderCreationError) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('خطأ'),
                                content: Text(NetworkErrorHandler.getErrorMessage(state.message)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('حسناً'),
                                  ),
                                ],
                              ),
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
            padding: EdgeInsets.symmetric(
              horizontal: _getResponsivePadding(context, 32),
              vertical: _getResponsivePadding(context, 16),
            ),
          ),
          child: Text(
            'اتمام الشراء',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo, 
              fontSize: _getResponsiveSize(context, 16)
            ),
          ),
        );
      },
    );
  }
}
