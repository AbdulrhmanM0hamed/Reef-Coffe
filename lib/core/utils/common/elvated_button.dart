import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final double? width;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.buttonText, 
    this.buttonColor,
    this.textColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          buttonText,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: textColor,
          ),
        ),
      ),
    );
  }
}