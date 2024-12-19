import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/custom_nav_pop.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/info_section.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/price_with_additons.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/review.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/title_with_favorite.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class DetailsViewBody extends StatefulWidget {
  final Product product;

  const DetailsViewBody({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<DetailsViewBody> createState() => _DetailsViewBodyState();
}

class _DetailsViewBodyState extends State<DetailsViewBody> {
  int _quantity = 1;

  void _updateQuantity(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 3.2 / 3,
                      child: Hero(
                        tag: 'product_image_${widget.product.id}_list',
                        child: CachedNetworkImage(
                          imageUrl: widget.product.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) {
                            return Icon(
                              Icons.error_outline,
                              color: Colors.grey.shade400,
                              size: 64,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 16,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                     
                          decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(16)
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 20,
                              color: TColors.black,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Color.fromARGB(255, 19, 19, 19)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        TitleWithFavorite(product: widget.product),
                        SizedBox(height: sizeHeight * 0.01),
                        PriceWithButton_add_min(
                          product: widget.product,
                          onQuantityChanged: _updateQuantity,
                        ),
                        SizedBox(height: sizeHeight * 0.015),
                        ReviewsWidget(product: widget.product),
                        SizedBox(height: sizeHeight * 0.015),
                        Text(
                          widget.product.description!,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: sizeWidth * 0.035,
                            color: TColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: sizeHeight * 0.020),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'معلومات المنتج',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: constraints.maxWidth * 0.045,
                                    color: TColors.darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GridView.count(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 1.8,
                                  children: [
                                    buildInfoCard(
                                      mainText: widget.product.expiryName!,
                                      subText: 'الصلاحية',
                                      iconInfo: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/calener.svg',
                                            width: 50,
                                            height: 70,
                                          ),
                                          Positioned(
                                            top: 25,
                                            child: Text(
                                              '${widget.product.expiryNumber.toInt()}',
                                              style: getBoldStyle(
                                                fontFamily: FontConstant.cairo,
                                                fontSize: 20,
                                                color: TColors.darkerGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    buildInfoCard(
                                      mainText: widget.product.isOrganic
                                          ? 'طبيعي'
                                          : 'غير طبيعي',
                                      subText: widget.product.isOrganic
                                          ? '100% طبيعي'
                                          : 'منتج مصنع',
                                      iconInfo: SvgPicture.asset(
                                        'assets/images/lotus.svg',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    buildInfoCard(
                                      mainText:
                                          '${widget.product.caloriesPer100g}',
                                      subText: 'سعرة حرارية',
                                      extraText: '100 جرام',
                                      iconInfo: SvgPicture.asset(
                                        'assets/images/calory.svg',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    buildInfoCard(
                                      mainText: '${widget.product.rating}',
                                      subText: 'تقييم',
                                      extraText:
                                          '${widget.product.ratingCount} مراجعة',
                                      iconInfo: SvgPicture.asset(
                                        'assets/images/favourites.svg',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: sizeHeight * 0.018),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              final cartItem = CartItem(
                                id: widget.product.id!,
                                productId: widget.product.id!,
                                name: widget.product.name,
                                price: widget.product.hasDiscount &&
                                        widget.product.discountPrice != null
                                    ? widget.product.discountPrice!
                                    : widget.product.price,
                                image: widget.product.imageUrl ?? '',
                                quantity: _quantity,
                              );

                              context.read<CartCubit>().addItem(cartItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'تم إضافة ${widget.product.name} إلى السلة'),
                                  backgroundColor: TColors.primary,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('حدث خطأ أثناء الإضافة إلى السلة'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "اضف الى السلة",
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
