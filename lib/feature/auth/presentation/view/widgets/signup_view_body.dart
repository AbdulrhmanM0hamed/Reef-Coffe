import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/common/custom_text_form_field.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/common/password_field.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signup/signup_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/custom_check_box.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/custom_phone_field.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/hava_an_account.dart';
import 'package:hyper_market/feature/auth/presentation/view/widgets/terms_and_condition.dart';
import 'package:hyper_market/generated/l10n.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password, userName, phoneNumber;
  bool isAgreed = false;

  String _normalizeSpaces(String value) {
    // Remove leading/trailing spaces and replace multiple spaces with single space
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    // Check for spaces in email
    if (value.contains(' ')) {
      return 'لا يمكن أن يحتوي البريد الإلكتروني على مسافات';
    }

    // تعبير منتظم أكثر مرونة للتحقق من صحة البريد الإلكتروني
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }

    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال اسمك الكامل';
    }
    
    // Check if the value contains only spaces
    if (value.trim().isEmpty) {
      return 'لا يمكن أن يتكون الاسم من مسافات فقط';
    }

    // Normalize spaces and check length
    String normalizedValue = _normalizeSpaces(value);
    if (normalizedValue.length < 4) {
      return 'الاسم يجب أن يكون 4 أحرف على الأقل';
    }

    // Ensure the name contains actual letters (Arabic or English) and allows spaces between words
    if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(normalizedValue)) {
      return 'الاسم يجب أن يحتوي على حروف فقط';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.03,
          horizontal: screenWidth * 0.05,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                onSaved: (value) => userName = _normalizeSpaces(value!),
                hintText: S.current!.fullName,
                suffixIcon: const Icon(Icons.person),
                validator: _validateName,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextFormField(
                onSaved: (value) => email = value!,
                hintText: S.current!.email,
                suffixIcon: const Icon(Icons.email),
                validator: _validateEmail,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomPhoneField(
                onSaved: (value) => phoneNumber = value!,
              ),
              SizedBox(height: screenHeight * 0.02),
              PasswordField(
                hintText: S.current!.password,
                onSaved: (value) => password = value!,
               
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckBox(
                    initialValue: isAgreed,
                    onChanged: (value) {
                      setState(() {
                        isAgreed = value;
                      });
                    },
                  ),
                  const TermsAndConditons(),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomElevatedButton(
                onPressed: () {
                  //    Prefs.setBool(KIsloginSuccess, true);
                  if (isAgreed) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      context
                          .read<SignUpCubit>()
                          .signUpWithEmail(email, password, userName, phoneNumber);
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  } else {
                    // عرض Snackbar إذا لم يقم المستخدم بالموافقة
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'يرجى الموافقة على الشروط والأحكام قبل المتابعة.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                buttonText: "إنشاء حساب جديد",
              ),
              const HavaAnAccount(),
            ],
          ),
        ),
      ),
    );
  }
}
