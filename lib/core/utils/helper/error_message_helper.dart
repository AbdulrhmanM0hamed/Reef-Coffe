import 'package:flutter/material.dart';

String getLocalizedErrorMessage(String errorMessage) {
  // Check for exact error messages from backend
  if (errorMessage.contains('Invalid login credentials')) {
    return 'البريد الإلكتروني او كلمة المرور غير صحيحة';
  }
  if (errorMessage.contains('Email not confirmed')) {
    return 'البريد الإلكتروني غير مؤكد. يرجى التحقق من بريدك الإلكتروني للتأكيد';
  }
  if (errorMessage.contains('Authentication failed')) {
    return 'فشل في تسجيل الدخول';
  }
  if (errorMessage.contains('Registration failed')) {
    return 'فشل في إنشاء الحساب';
  }
  if (errorMessage.contains('Google sign in failed')) {
    return 'فشل في تسجيل الدخول بواسطة Google';
  }
  if (errorMessage.contains('Facebook sign in failed')) {
    return 'فشل في تسجيل الدخول بواسطة Facebook';
  }
  if (errorMessage.contains('تأكد من البريد الإلكتروني وكلمة المرور')) {
    return 'تأكد من البريد الإلكتروني وكلمة المرور';
  }

  // If no match found, return the original message
  return errorMessage;
}

void showErrorSnackBar(BuildContext context, String message) {
  final String localizedMessage = getLocalizedErrorMessage(message);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(localizedMessage),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    ),
  );
}
