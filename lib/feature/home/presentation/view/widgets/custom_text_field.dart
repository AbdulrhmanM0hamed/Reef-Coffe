import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "ابحث عن المنتج الذي تريده",
        prefixIcon: SizedBox(width: 20 , child: Center(child: SvgPicture.asset("assets/images/search_icon.svg"  , width: 25,))),
        suffixIcon: SizedBox(width: 20 , child: Center(child: SvgPicture.asset("assets/images/filter.svg" , width: 25,)))
      ),
    );
  }
}
