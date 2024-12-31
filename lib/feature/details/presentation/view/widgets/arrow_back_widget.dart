import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';

class ArrowBackWidget extends StatelessWidget {
  const ArrowBackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).brightness == Brightness.dark
            ? TColors.darkerGrey.withOpacity(0.7)
            : TColors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () =>  Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 12.0 : 8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: isTablet ? 28.0 : 24.0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.white
                  : TColors.dark,
            ),
          ),
        ),
      ),
    );
  }
}
