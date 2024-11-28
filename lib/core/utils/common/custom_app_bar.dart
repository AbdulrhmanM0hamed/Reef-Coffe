import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

AppBar customAppBar(BuildContext context , String title) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
        Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back_ios_new_outlined)) ,
    
      centerTitle: true,
      title: Text(title , style: getBoldStyle(fontFamily: FontConstant.cairo , fontSize: 20.0),),
    );
  } 
