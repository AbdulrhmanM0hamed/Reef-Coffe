import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/widgets/add_and_del.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class PriceWithButtonAddMin extends StatefulWidget {
  final Product product;
  final Function(int quantity) onQuantityChanged;

  const PriceWithButtonAddMin({
    super.key,
    required this.product,
    required this.onQuantityChanged,
  });

  @override
  State<PriceWithButtonAddMin> createState() => PriceWithButtonAddMinState();
}

class PriceWithButtonAddMinState extends State<PriceWithButtonAddMin> {
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
    final sizeWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.product.hasDiscount)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.product.discountPrice?.toStringAsFixed(2)} ريال',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: sizeWidth * 0.04,
                  color: Colors.red.shade700,
                ),
              ),
              Text(
                '${widget.product.price.toStringAsFixed(2)} ريال',
                style: TextStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: sizeWidth * 0.035,
                  color: Colors.grey.shade700,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.grey.shade600,
                  decorationThickness: 1,
                ),
              ),
            ],
          )
        else
          Text(
            '${widget.product.price.toStringAsFixed(2)} ريال',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: sizeWidth * 0.04,
              color: Colors.red,
            ),
          ),
        AddAndDeleteItem(
          sizeWidth: sizeWidth,
          number: quantity,
          onPressedAdd: _incrementQuantity,
          onPressedDel: _decrementQuantity,
        ),
      ],
    );
  }
}
