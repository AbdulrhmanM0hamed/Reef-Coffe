import 'dart:io';

import 'package:flutter/material.dart';

class NetworkErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';
    } else if (error is HttpException) {
      return 'حدث خطأ في الاتصال بالخادم. يرجى المحاولة مرة أخرى.';
    } else if (error is FormatException) {
      return 'حدث خطأ في معالجة البيانات. يرجى المحاولة مرة أخرى.';
    } else {
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }

  static Widget buildErrorWidget(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
