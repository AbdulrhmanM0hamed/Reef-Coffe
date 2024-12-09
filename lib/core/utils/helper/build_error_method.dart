import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';

void buildErroMessage(BuildContext context,  String message) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: TColors.error,
        content: Text(message),
      ),
    );
  }
