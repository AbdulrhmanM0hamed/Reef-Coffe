
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/values_manger.dart';
import 'package:hyper_market/feature/auth/presentation/view/verification_code_view.dart';

class ForgetPasswordViewBody extends StatelessWidget {
  const ForgetPasswordViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        // const  CustomTextFormField(
          
        //     hintText: "ادخل رقم الهاتف ", 
        //     icon:  Icon(Icons.phone),
        //   ),
          const SizedBox(height: AppSize.s20),
          CustomElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, VerificationCodeView.routeName);
            },
            buttonText: "نسيت كلمة المرور "
          ),
        ],
      ),
    );
  }
}
