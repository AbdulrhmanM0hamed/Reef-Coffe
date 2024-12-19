import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/common/password_field.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/controller/reset_password/reset_password_state.dart';

class NewPasswordView extends StatelessWidget {
  static const String routeName = "newPassword";
  final String email;

  const NewPasswordView({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(
        authRepository: getIt(),
        email: email,
      ),
      child: Builder(
        builder: (context) {
          final formKey = GlobalKey<FormState>();
          final TextEditingController passwordController = TextEditingController();
          final TextEditingController confirmPasswordController = TextEditingController();

          return BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is PasswordResetSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacementNamed(context, '/login');
              } else if (state is ResetPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(title: const Text('تعيين كلمة المرور الجديدة')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      PasswordField(
                        hintText: 'كلمة المرور الجديدة',
                        onSaved: (value) => passwordController.text = value!,
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        hintText: 'تأكيد كلمة المرور',
                        onSaved: (value) => confirmPasswordController.text = value!,
                      ),
                      const SizedBox(height: 24),
                      CustomElevatedButton(
                        buttonText: 'تحديث كلمة المرور',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            if (passwordController.text != confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('كلمتا المرور غير متطابقتين'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            context.read<ResetPasswordCubit>().resetPassword(
                              passwordController.text,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
