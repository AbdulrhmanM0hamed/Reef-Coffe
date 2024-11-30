import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

AppBar customAppBar(BuildContext context, String title, {bool loginScreen = false}) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        if (loginScreen) {
          SystemNavigator.pop();
        } else {
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: getBoldStyle(fontFamily: FontConstant.cairo, fontSize: 20.0),
    ),
  );
}
