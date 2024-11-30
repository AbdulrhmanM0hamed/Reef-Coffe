
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Divider(color: TColors.darkGrey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "أو",
            style: getSemiBoldStyle(fontFamily: FontConstant.cairo, fontSize: FontSize.size18, color: TColors.textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: TColors.darkGrey)),
      ],
    );
  }
}
