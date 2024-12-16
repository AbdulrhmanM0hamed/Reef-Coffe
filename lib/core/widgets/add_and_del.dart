import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class AddAndDeleteItem extends StatelessWidget {
  const AddAndDeleteItem({
    super.key,
    required this.sizeWidth,
    required this.onPressedAdd,
    required this.onPressedDel,
    required this.number,
  });
  final void Function() onPressedAdd;
  final void Function() onPressedDel;
  final int number;
  final double sizeWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: sizeWidth * 0.08,
          height: sizeWidth * 0.08,
          decoration: BoxDecoration(
            color: TColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: GestureDetector(
            child: IconButton(
              onPressed: onPressedAdd,
              icon: Icon(
                Icons.add,
                size: sizeWidth * 0.040,
              ),
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.black
                  : TColors.white,
            ),
          ),
        ),
        SizedBox(width: sizeWidth * 0.03),
        Text(
          "$number",
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: sizeWidth * 0.045,
          ),
        ),
        SizedBox(width: sizeWidth * 0.01),
        IconButton(
            onPressed: onPressedDel,
            icon: Icon(
              Icons.remove,
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.grey
                  : TColors.black,
              size: sizeWidth * 0.055,
            )),
      ],
    );
  }
}
