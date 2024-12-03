import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class PayingButton extends StatelessWidget {
  const PayingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 12,
        ),
      ),
      child: Text(
        'إتمام الشراء',
        style: getBoldStyle(
            fontFamily: FontConstant.cairo, fontSize: FontSize.size16),
      ),
    );
  }
}
