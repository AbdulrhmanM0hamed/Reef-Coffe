import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  void _submitOrder() {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/order_request.svg',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'تم اضافة الطلب بنجاح',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(_getResponsivePadding(context, 16)),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(_getResponsivePadding(context, 20)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: _getResponsivePadding(context, 50),
                  height: _getResponsivePadding(context, 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                        _getResponsivePadding(context, 2)),
                  ),
                ),
              ),
              SizedBox(height: _getResponsivePadding(context, 16)),
              Text(
                'معلومات الطلب',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: _getResponsiveFontSize(context, 18),
                  color: TColors.dark,
                ),
              ),
              SizedBox(height: _getResponsivePadding(context, 16)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: _validateName,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'الاسم',
                        hintText: 'ادخل اسمك الكامل',
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          size: _getResponsiveIconSize(context, 24),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              _getResponsivePadding(context, 8)),
                        ),
                      ),
                    ),
                    SizedBox(height: _getResponsivePadding(context, 16)),
                    TextFormField(
                      controller: _phoneController,
                      validator: _validatePhone,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        hintText: '01xxxxxxxxx',
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          size: _getResponsiveIconSize(context, 24),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              _getResponsivePadding(context, 8)),
                        ),
                      ),
                    ),
                    SizedBox(height: _getResponsivePadding(context, 16)),
                    TextFormField(
                      controller: _addressController,
                      validator: _validateAddress,
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'عنوان التوصيل',
                        hintText: 'ادخل عنوان التوصيل كامل مع رقم المبنى/الشقة',
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          size: _getResponsiveIconSize(context, 24),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              _getResponsivePadding(context, 8)),
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                    SizedBox(height: _getResponsivePadding(context, 16)),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: _submitOrder,
                        buttonText: 'تأكيد الطلب',
                      ),
                    ),
                    SizedBox(height: _getResponsivePadding(context, 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
