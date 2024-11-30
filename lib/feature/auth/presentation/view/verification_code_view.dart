
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class VerificationCodeView extends StatelessWidget {
  const VerificationCodeView({super.key});
  static const String routeName = "verificationCode";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "التحقق من الرمز") ,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
           Text.rich(
                    TextSpan(
                      text: "ادخل الرمز الذى أرسلناه إالى عنوان بريد التالى ",
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16, // Responsive font size
                        color: TColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: "abdo@gmail.com",
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size18, // Responsive font size
                            color: TColors.primary,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start, // Aligns text to start
                    overflow: TextOverflow
                        .clip, // Allows text to wrap to the next line
                  ),
           const   SizedBox(
                    height: 20,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:const BorderSide(color: Color.fromARGB(255, 231, 186, 102) , )
                        
                      ) ,
                      counterText: "", 
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(4)
                      ),
                    ),
                    style: getBoldStyle(fontFamily: FontConstant.cairo , fontSize: FontSize.size24),
                  ),
                );
              }),
            ),
        const    SizedBox(height: 26,) ,
  CustomElevatedButton(onPressed: (){}, buttonText: "تحقق من الرمز "),
 const SizedBox(
    height: 24,
  ),
  Text("إعادة إرسال الرمز" , style: getSemiBoldStyle(fontFamily: FontConstant.cairo,  color: TColors.primary , fontSize: FontSize.size18))
          ],
        ),
      ),
    );
  }
}
