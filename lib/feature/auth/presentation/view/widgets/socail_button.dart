import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final String iconPath;

  const SocialButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: TColors.darkGrey),
        minimumSize: Size(double.infinity, size.height * 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.08,
            child: SvgPicture.asset(iconPath, height: size.height * 0.03, width: size.height * 0.03),
          ),
          SizedBox(width: size.width * 0.025),
          Expanded(
            child: Text(
              buttonText,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: TColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
