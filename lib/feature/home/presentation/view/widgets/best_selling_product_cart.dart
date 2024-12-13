// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hyper_market/core/utils/constants/colors.dart';
// import 'package:hyper_market/core/utils/constants/font_manger.dart';
// import 'package:hyper_market/core/utils/constants/styles_manger.dart';
// import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
// import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';

// class BestSellingProducts extends StatelessWidget {
//   const BestSellingProducts({
//     super.key,
//     required this.sizeWidth,
//     required this.sizeHeight,
//   });

//   final double sizeWidth;
//   final double sizeHeight;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: sizeWidth * 0.04,
//         right: sizeWidth * 0.02,
//       ),
//       child: Container(
//         width: sizeWidth * 0.35, // عرض الكارت
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[500]!),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               spreadRadius: 1,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(sizeWidth * 0.03),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Center(
//                   child: Image.asset(
//                     "assets/images/Apple.png",
//                     fit: BoxFit.contain,
//                     height: sizeHeight * 0.17,
//                     width: sizeWidth * 0.30,
//                   ),
//                 ),
//               ),
//               SizedBox(height: sizeHeight * 0.015),
//               Text(
//                 "تفاح أحمر",
//                 style: getBoldStyle(
//                   fontFamily: FontConstant.cairo,
//                   fontSize: FontSize.size16,
//                 ),
//               ),
//               SizedBox(height: sizeHeight * 0.005),
//               Text(
//                 "1 كيلو, سعر",
//                 style: getBoldStyle(
//                   fontFamily: FontConstant.cairo,
//                   fontSize: FontSize.size14,
//                   color: TColors.secondary,
//                 ),
//               ),
//               SizedBox(height: sizeHeight * 0.01),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "\$4.99",
//                         style: getBoldStyle(
//                           fontFamily: FontConstant.cairo,
//                           fontSize: sizeWidth * 0.045,
//                         ),
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       final cartItem = CartItem(
//                         discountPrice: 4.99,
//                         id: DateTime.now().toString(), // يمكن استبدالها بID حقيقي
//                         productId: "apple_1", // يمكن استبدالها بID حقيقي
//                         name: "تفاح أحمر",
//                         price: 6,
//                         image: "assets/images/Apple.png",
//                       );
//                       context.read<CartCubit>().addItem(cartItem);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           backgroundColor: TColors.primary,
//                           content: Text('تم إضافة المنتج إلى سلة التسوق'),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: sizeWidth * 0.08,
//                       height: sizeWidth * 0.08,
//                       decoration: BoxDecoration(
//                         color: TColors.primary,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.add,
//                         color: Theme.of(context).brightness == Brightness.dark
//                             ? TColors.black
//                             : TColors.white,
//                         size: sizeWidth * 0.05,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
