import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'من فضلك ادخل الاسم';
    }
    if (value.length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    if (value.length > 50) {
      return 'الاسم لا يجب أن يتجاوز 50 حرف';
    }
    if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(value)) {
      return 'الاسم يجب أن يحتوي على حروف فقط';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'من فضلك ادخل رقم الهاتف';
    }
    // Phone number validation for 12 digits
    if (!RegExp(r'^\d{12}$').hasMatch(value)) {
      return 'رقم الهاتف يجب أن يكون 12 رقم';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'من فضلك ادخل العنوان';
    }
    if (value.length < 10) {
      return 'العنوان يجب أن يكون 10 أحرف على الأقل';
    }
    if (value.length > 200) {
      return 'العنوان لا يجب أن يتجاوز 200 حرف';
    }
    // Check if address has numbers (like building number, apartment number)
   
    return null;
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
        name: _nameController.text,
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
                TextFormField(
                  controller: _nameController,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'الاسم',
                    hintText: 'ادخل اسمك الكامل',
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    hintText: '01xxxxxxxxx',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  validator: _validateAddress,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'عنوان التوصيل',
                    hintText: 'ادخل عنوان التوصيل كامل مع رقم المبنى/الشقة',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
}
