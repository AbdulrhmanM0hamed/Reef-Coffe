import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Color color ; 

  const ProductCard({
    Key? key,

    required this.imageUrl,
    required this.title, required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
              width: 100,
              height: 80,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class Groceries extends StatelessWidget {
   Groceries({super.key});
   

  final List<Map<String, dynamic>> products = [
    {
      "image": "assets/images/1.png",
      "title": "المنتجات الغذائية",
       "color" : TColors.accent.withOpacity(.49)   
    },
    {
      "image": "assets/images/2.png",
      "title": "المخبوزات والحلويات",
       "color" : TColors.primary.withOpacity(.18) 
    },
    {
      "image": "assets/images/3.png",
      "title": "المشروبات",
      "color" : TColors.secondary.withOpacity(.2) 
      
    },
    {
      "image": "assets/images/4.png",
      "title": "المعلبات والمجمدات",
      "color" : TColors.error.withOpacity(.18) 
      
    },
    {
      "image": "assets/images/5.png",
      "title": "الحلويات والمقرمشات",
      "color" : TColors.warning.withOpacity(.18) 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ProductCard(
              color:product["color"] ,
              imageUrl: product["image"]!,
              title: product["title"]!,
            ),
          );
        },
      ),
    );
  }
}
