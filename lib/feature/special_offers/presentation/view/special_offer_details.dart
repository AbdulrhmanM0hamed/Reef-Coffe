// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hyper_market/core/services/service_locator.dart';
// import 'package:hyper_market/core/utils/common/elvated_button.dart';
// import 'package:hyper_market/core/utils/constants/colors.dart';
// import 'package:hyper_market/core/utils/constants/font_manger.dart';
// import 'package:hyper_market/core/utils/constants/styles_manger.dart';
// import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
// import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
// import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';
// import 'package:hyper_market/feature/special_offers/presentation/widgets/offer_quantity_selector.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:math';


// class SpecialOfferDetails extends StatefulWidget {
//   final SpecialOffer offer;
//   static const String routeName = 'special-offer-details';

//   const SpecialOfferDetails({super.key, required this.offer});

//   @override
//   State<SpecialOfferDetails> createState() => _SpecialOfferDetailsState();
// }

// class _SpecialOfferDetailsState extends State<SpecialOfferDetails> {
//   int _quantity = 1;

//   void _updateQuantity(int quantity) {
//     setState(() {
//       _quantity = quantity;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return BlocProvider.value(
//       value: getIt<CartCubit>(),
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: size.height * 0.45,
//                 child: Stack(
//                   children: [
//                     AspectRatio(
//                       aspectRatio: 3.2 / 3,
//                       child: Hero(
//                         tag: 'offer_image_${widget.offer.id}',
//                         child: CachedNetworkImage(
//                           imageUrl: widget.offer.image1,
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => const Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                           errorWidget: (context, url, error) => Icon(
//                             Icons.error_outline,
//                             color: Colors.grey.shade400,
//                             size: 64,
//                           ),
//                         ),
//                       ),
//                     ),


//                     Positioned(
//                       top: 40,
//                       right: 16,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(
//                             Icons.arrow_back_ios_new_outlined,
//                             size: 20,
//                             color: TColors.black,
//                           ),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Transform.translate(
//                 offset: const Offset(0, -40),
//                 child: Container(
//                   padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? const Color.fromARGB(255, 19, 19, 19)
//                         : Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.offer.title,
//                                   style: getBoldStyle(
//                                     fontFamily: FontConstant.cairo,
//                                     fontSize: FontSize.size24,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   widget.offer.subtitle,
//                                   style: getMediumStyle(
//                                     fontFamily: FontConstant.cairo,
//                                     fontSize: FontSize.size16,
//                                     color: TColors.darkerGrey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: TColors.primary,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               '${widget.offer.offerPrice} جنيه',
//                               style: getBoldStyle(
//                                 fontFamily: FontConstant.cairo,
//                                 fontSize: FontSize.size18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // الوصف
//                       Text(
//                         'تفاصيل العرض',
//                         style: getBoldStyle(
//                           fontFamily: FontConstant.cairo,
//                           fontSize: FontSize.size18,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         widget.offer.description,
//                         style: getRegularStyle(
//                           fontFamily: FontConstant.cairo,
//                           fontSize: FontSize.size16,
//                           color: TColors.secondary,
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // المنتجات المشمولة
//                       if (widget.offer.includedItems.isNotEmpty) ...[
//                         Text(
//                           'مميزات العرض',
//                           style: getBoldStyle(
//                             fontFamily: FontConstant.cairo,
//                             fontSize: FontSize.size18,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: TColors.primary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             children: widget.offer.includedItems
//                                 .map(
//                                   (item) => Padding(
//                                     padding: const EdgeInsets.only(bottom: 4),
//                                     child: Row(
//                                       children: [
//                                         const Icon(
//                                           Icons.check_circle,
//                                           color: TColors.primary,
//                                           size: 20,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Expanded(
//                                           child: Text(
//                                             item,
//                                             style: getRegularStyle(
//                                               fontFamily: FontConstant.cairo,
//                                               fontSize: FontSize.size16,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                       const SizedBox(height: 12),

//                       // شروط العرض
//                       if (widget.offer.terms.isNotEmpty) ...[
//                         Text(
//                           'شروط العرض',
//                           style: getBoldStyle(
//                             fontFamily: FontConstant.cairo,
//                             fontSize: FontSize.size18,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Column(
//                           children: widget.offer.terms
//                               .map(
//                                 (term) => Padding(
//                                   padding: const EdgeInsets.only(bottom: 4),
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const Icon(
//                                         Icons.info_outline,
//                                         color: TColors.primary,
//                                         size: 20,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: Text(
//                                           term,
//                                           style: getRegularStyle(
//                                             fontFamily: FontConstant.cairo,
//                                             fontSize: FontSize.size14,
//                                             color: TColors.secondary,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       ],
                      
//                       const SizedBox(height: 24),
                      
//                       if (widget.offer.isValid) ...[
//                         Column(
//                           children: [
//                             OfferQuantitySelector(
//                               offer: widget.offer,
//                               onQuantityChanged: _updateQuantity,
//                             ),
//                             const SizedBox(height: 16),
//                             BlocListener<CartCubit, CartState>(
//                               listener: (context, state) {
//                                 if (state is CartUpdated) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('تم إضافة العرض إلى السلة بنجاح'),
//                                       backgroundColor: TColors.primary,
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: CustomElevatedButton(
//                                 buttonText: 'اضافة للسلة',
//                                 onPressed: () {
//                                   try {
//                                     if (_quantity <= 0) {
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         const SnackBar(
//                                           content: Text('الرجاء تحديد الكمية'),
//                                           backgroundColor: Colors.red,
//                                           duration: Duration(seconds: 2),
//                                         ),
//                                       );
//                                       return;
//                                     }

//                                     final cartItem = CartItem(
//                                       id: widget.offer.id,
//                                       productId: widget.offer.id,
//                                       name: widget.offer.title,
//                                       price: widget.offer.offerPrice,
//                                       image: widget.offer.image1,
//                                       quantity: _quantity,
//                                     );

//                                     getIt<CartCubit>().addItem(cartItem);
//                                   } catch (e) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text('حدث خطأ أثناء إضافة العرض إلى السلة'),
//                                         backgroundColor: TColors.error,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ] else ...[
//                         // Show message if offer is not valid
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: TColors.error.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.error_outline,
//                                 color: TColors.error,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   'هذا العرض غير متاح حالياً',
//                                   style: getMediumStyle(
//                                     fontFamily: FontConstant.cairo,
//                                     fontSize: FontSize.size14,
//                                     color: TColors.error,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],

//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
