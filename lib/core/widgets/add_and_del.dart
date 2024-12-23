import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class AddAndDeleteItem extends StatelessWidget {
  final double sizeWidth;
  final int number;
  final VoidCallback onPressedAdd;
  final VoidCallback onPressedDel;
  static const int maxQuantity = 30;

  const AddAndDeleteItem({
    Key? key,
    required this.sizeWidth,
    required this.number,
    required this.onPressedAdd,
    required this.onPressedDel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = sizeWidth < 360;
    final isMediumScreen = sizeWidth < 600;
    
    final buttonSize = _getButtonSize(sizeWidth);
    final iconSize = _getIconSize(sizeWidth);
    final fontSize = _getFontSize(sizeWidth);
    final horizontalPadding = _getHorizontalPadding(sizeWidth);

    return Container(
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isMediumScreen ? 8 : 12),
      ),
      child: Row(
        children: [
          _buildControlButton(
            context: context,
            icon: Icons.remove,
            onPressed: onPressedDel,
            size: buttonSize,
            iconSize: iconSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              number.toString(),
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: fontSize,
                color: TColors.primary,
              ),
            ),
          ),
          _buildControlButton(
            context: context,
            icon: Icons.add,
            onPressed: () {
              if (number < maxQuantity) {
                onPressedAdd();
              } else {
                _showMaxQuantityMessage(context);
              }
            },
            size: buttonSize,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required double size,
    required double iconSize,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: TColors.primary,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  void _showMaxQuantityMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'عذراً، الحد الأقصى للطلب هو $maxQuantity قطع',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double _getButtonSize(double screenWidth) {
    if (screenWidth < 360) return 32;
    if (screenWidth < 600) return 36;
    return 42;
  }

  double _getIconSize(double screenWidth) {
    if (screenWidth < 360) return 16;
    if (screenWidth < 600) return 18;
    return 22;
  }

  double _getFontSize(double screenWidth) {
    if (screenWidth < 360) return FontSize.size14;
    if (screenWidth < 600) return FontSize.size16;
    return FontSize.size18;
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 360) return 8;
    if (screenWidth < 600) return 12;
    return 16;
  }
}
