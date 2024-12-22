import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';

class QuantityControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const QuantityControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: TColors.primary,
        size: size,
      ),
    );
  }
}
