import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';

import 'package:hyper_market/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/cubit/profile_state.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/custom_text_filed.dart';

class UpdateNameView extends StatefulWidget {
  const UpdateNameView({Key? key}) : super(key: key);

  static const String routeName = '/update-name';

  @override
  State<UpdateNameView> createState() => _UpdateNameViewState();
}

class _UpdateNameViewState extends State<UpdateNameView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الاسم';
    }
    
    // التحقق من طول الاسم
    if (value.length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    if (value.length > 20) {
      return 'الاسم يجب ألا يتجاوز 20 حرف';
    }

    // التحقق من أن الاسم يحتوي على أحرف صالحة فقط
    final validNameRegex = RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$');
    if (!validNameRegex.hasMatch(value)) {
      return 'الاسم يجب أن يحتوي على أحرف عربية أو إنجليزية فقط';
    }

    // التحقق من عدم وجود مسافات متتالية
    if (value.contains(RegExp(r'\s{2,}'))) {
      return 'الاسم لا يجب أن يحتوي على مسافات متتالية';
    }

    // التحقق من أن الاسم لا يبدأ أو ينتهي بمسافة
    if (value.startsWith(' ') || value.endsWith(' ')) {
      return 'الاسم لا يجب أن يبدأ أو ينتهي بمسافة';
    }

    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'تغيير الاسم'),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'الاسم الجديد',
                    validator: _validateName,
                  ),
                  const SizedBox(height: 24),
                  if (state is ProfileLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<ProfileCubit>()
                                .updateName(_nameController.text.trim());
                          }
                        },
                        buttonText: 'تحديث',
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
