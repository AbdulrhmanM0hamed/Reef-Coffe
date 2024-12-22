import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';
import 'package:hyper_market/feature/special_offers/presentation/widgets/price_display.dart';
import 'package:hyper_market/feature/special_offers/presentation/widgets/quantity_control_button.dart';
import 'package:hyper_market/feature/special_offers/presentation/widgets/quantity_display.dart';

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

  void _incrementQuantity() {
    setState(() {
      quantity++;
      widget.onQuantityChanged(quantity);
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onQuantityChanged(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final fontSize = _getFontSize(size);
    final iconSize = _getIconSize(size);
    final padding = _getPadding(size);

    return Container(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // السعر
          PriceDisplay(
            price: widget.offer.offerPrice,
            fontSize: fontSize,
          ),

          // التحكم في الكمية
          Container(
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // زر النقص
                QuantityControlButton(
                  icon: Icons.remove,
                  onPressed: _decrementQuantity,
                  size: iconSize,
                ),
                
                // عرض الكمية
                QuantityDisplay(
                  quantity: quantity,
                  fontSize: fontSize,
                ),
                
                // زر الزيادة
                QuantityControlButton(
                  icon: Icons.add,
                  onPressed: _incrementQuantity,
                  size: iconSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size14;
    } else if (size.width < 600) {
      return FontSize.size16;
    }
    return FontSize.size20;
  }

  double _getIconSize(Size size) {
    if (size.width < 360) {
      return 20;
    } else if (size.width < 600) {
      return 24;
    }
    return 28;
  }

  double _getPadding(Size size) {
    if (size.width < 360) {
      return 6;
    } else if (size.width < 600) {
      return 8;
    }
    return 12;
  }
}
