import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneField extends StatelessWidget {
  final Function(String?) onSaved;

  const CustomPhoneField({
    super.key,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "ادخل رقم الهاتف",
        suffixIcon: Icon(Icons.phone),
      ),
      onSaved: onSaved,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
      ],
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'يرجى إدخال رقم الهاتف';
        }

        return null;
      },
    );
  }
}
