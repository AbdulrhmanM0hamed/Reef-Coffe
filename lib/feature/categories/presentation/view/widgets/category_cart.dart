import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/categories/domain/entities/category.dart';
import 'package:hyper_market/feature/products/presentation/view/products_view.dart';
import 'package:page_transition/page_transition.dart';

class CategoryCart extends StatelessWidget {
  const CategoryCart({
    super.key,
    required this.category,
    required this.colorIndex,
  });

  final Category category;
  final int colorIndex;

  static const List<Color> categoryColors = [
    Color(0x33FF6B6B), // أحمر فاتح
    Color(0x334ECDC4), // تركواز
    Color.fromARGB(51, 192, 160, 34), // أصفر
    Color(0x336C5CE7), // أزرق
    Color.fromARGB(143, 168, 230, 207), // نعناعي
    Color.fromARGB(115, 139, 176, 255), // وردي
    Color.fromARGB(108, 181, 247, 161), // بنفسجي
    Color.fromARGB(69, 72, 129, 129), // سلموني
  ];

  Color get cardColor => categoryColors[colorIndex % categoryColors.length];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: ProductsView(category: category),
            duration: const Duration(milliseconds: 250),
            reverseDuration: const Duration(milliseconds: 250),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: size.width * 0.4,
                padding: EdgeInsets.all(size.width * 0.02),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                  child: CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: size.width * 0.08,
                      );
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                category.name,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: _getTitleFontSize(size),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getTitleFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size14;
    } else if (size.width < 600) {
      return FontSize.size16;
    }
    return FontSize.size18;
  }
}
