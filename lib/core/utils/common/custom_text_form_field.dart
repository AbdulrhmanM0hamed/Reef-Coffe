import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key, 
    required this.hintText, 
    required this.suffixIcon, 
    required this.onSaved,  
    this.obsacureText = false,
    this.validator,
  });

  final String hintText;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final bool obsacureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsacureText,
      onSaved: onSaved,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}