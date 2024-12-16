import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/cart/presentation/widgets/bottom_sheet_text_field.dart';
import 'package:hyper_market/feature/orders/data/models/order_model.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CheckoutBottomSheet extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const CheckoutBottomSheet({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _name = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<OrdersCubit>(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اتمام الطلب',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size20,
                  ),
                ),
                const SizedBox(height: 24),
                BottomSheetTextField(
                  controller: _name,
                  labelText: 'الاسم',
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك ادخل الاسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                BottomSheetTextField(
                  controller: _addressController,
                  labelText: 'عنوان التوصيل',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك ادخل عنوان التوصيل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                BottomSheetTextField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك ادخل رقم الهاتف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocProvider.value(
                  value: context.read<CartCubit>(),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: _submitOrder,
                      buttonText: "تأكيد الطلب",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final supabaseClient = Supabase.instance.client;

  void _submitOrder() {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: TColors.primary,
            content: Text('تم اضافة الطلب بنجاح ')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final orderItems = widget.cartItems
          .map((item) => OrderItemModel(
                imageUrl: item.image,
                productId: item.productId,
                productName: item.name,
                price: item.price!,
                quantity: item.quantity,
              ))
          .toList();

      final order = OrderModel(
        name: _name.text,
        id: const Uuid().v4(),
        userId: userId,
        items: orderItems,
        totalAmount: widget.totalAmount,
        status: 'pending',
        createdAt: DateTime.now(),
        deliveryAddress: _addressController.text,
        phoneNumber: _phoneController.text,
      );
      context.read<OrdersCubit>().createOrder(order);
    }
  }
}
