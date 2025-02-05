import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/custom_text_form_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key, 
    this.onSaved, required this.hintText, 
  });

  final void Function(String?)? onSaved;
  final String hintText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; 

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      obsacureText: _obscureText, // تمرير قيمة _obscureText
      onSaved: widget.onSaved, // تمرير onSaved
      hintText: widget.hintText,
      validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب ان تكون 6 حروف على الاقل';
                  }
                  return null;
                },
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText; 
          });
        },
        child: Icon(
          _obscureText ? Icons.remove_red_eye : Icons.visibility_off, // تغيير الأيقونة بناءً على الحالة
        ),
      ),
    );
  }
}
