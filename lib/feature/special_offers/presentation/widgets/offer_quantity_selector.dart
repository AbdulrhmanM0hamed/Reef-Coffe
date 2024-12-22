import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';

class OfferQuantitySelector extends StatefulWidget {
  final SpecialOffer offer;
  final Function(int) onQuantityChanged;

  const OfferQuantitySelector({
    Key? key,
    required this.offer,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<OfferQuantitySelector> createState() => _OfferQuantitySelectorState();
}

class _OfferQuantitySelectorState extends State<OfferQuantitySelector> {
  int quantity = 1;
  static const int maxQuantity = 10;

  void _incrementQuantity() {
    if (quantity < maxQuantity) {
      setState(() {
        quantity++;
        widget.onQuantityChanged(quantity);
      });
    } else {
      _showMaxQuantityMessage();
    }
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onQuantityChanged(quantity);
      });
    }
  }

  void _showMaxQuantityMessage() {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isMediumScreen = size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMediumScreen ? 8 : 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPriceSection(isSmallScreen),
          _buildQuantityControls(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildPriceSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السعر',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: isSmallScreen ? FontSize.size14 : FontSize.size16,
            color: TColors.darkGrey,
          ),
        ),
        Text(
          '${widget.offer.offerPrice} جنيه',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: isSmallScreen ? FontSize.size18 : FontSize.size20,
            color: TColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls(bool isSmallScreen) {
    final buttonSize = _getButtonSize(isSmallScreen);
    final iconSize = _getIconSize(isSmallScreen);
    final fontSize = _getFontSize(isSmallScreen);
    final padding = _getPadding(isSmallScreen);

    return Container(
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
      ),
      child: Row(
        children: [
          _buildControlButton(
            icon: Icons.remove,
            onPressed: _decrementQuantity,
            size: buttonSize,
            iconSize: iconSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Text(
              quantity.toString(),
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: fontSize,
                color: TColors.primary,
              ),
            ),
          ),
          _buildControlButton(
            icon: Icons.add,
            onPressed: _incrementQuantity,
            size: buttonSize,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
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

  double _getButtonSize(bool isSmallScreen) {
    if (isSmallScreen) return 32;
    return 42;
  }

  double _getIconSize(bool isSmallScreen) {
    if (isSmallScreen) return 16;
    return 22;
  }

  double _getFontSize(bool isSmallScreen) {
    if (isSmallScreen) return FontSize.size14;
    return FontSize.size18;
  }

  double _getPadding(bool isSmallScreen) {
    if (isSmallScreen) return 8;
    return 16;
  }
}
