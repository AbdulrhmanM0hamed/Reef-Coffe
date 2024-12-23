import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';

class ArrowBackWidget extends StatelessWidget {
  const ArrowBackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: TColors.white, borderRadius: BorderRadius.circular(16)),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: TColors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
