import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class BottomSheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const BottomSheetTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(context, 16),
        vertical: _getResponsivePadding(context, 8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textDirection: TextDirection.rtl,
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: _getResponsiveFontSize(context, 16),
          color: TColors.dark,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: _getResponsiveFontSize(context, 14),
            color: TColors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: _getResponsivePadding(context, 16),
            vertical: _getResponsivePadding(context, 12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getResponsivePadding(context, 8)),
          ),
          prefixIcon: prefixIcon,
        ),
        validator: validator,
      ),
    );
  }
}
