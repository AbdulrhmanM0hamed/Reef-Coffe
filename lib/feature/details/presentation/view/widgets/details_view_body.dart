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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomNavPop(),
            Hero(
              tag: 'product_image_${widget.product.id}_list',
              child: Container(
                width: double.infinity,
                height: sizeHeight * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.product.imageUrl ?? '',
                  fit: BoxFit.contain,
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
            SizedBox(height: sizeHeight * 0.01),
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
            SizedBox(height: sizeHeight * 0.025),
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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
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
                          mainText: widget.product.isOrganic ? 'طبيعي' : 'غير طبيعي',
                          subText:
                              widget.product.isOrganic ? '100% طبيعي' : 'منتج مصنع',
                          iconInfo: SvgPicture.asset(
                            'assets/images/lotus.svg',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        buildInfoCard(
                          mainText: '${widget.product.caloriesPer100g}',
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
                          extraText: '${widget.product.ratingCount} مراجعة',
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
                print('Add to cart button pressed');
                try {
                  final cartItem = CartItem(
                    id: widget.product.id!,
                    productId: widget.product.id!,
                    name: widget.product.name,
                    price: widget.product.discountPrice == 0.0
                        ? widget.product.price
                        : widget.product.discountPrice,
                    image: widget.product.imageUrl!,
                    quantity: _quantity,
                  );
                  print('CartItem created: ${cartItem.name} with quantity: ${cartItem.quantity}');

                  context.read<CartCubit>().addItem(cartItem);
                  print('AddItem called on CartCubit');
                } catch (e) {
                  print('Error creating cart item: $e');
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
            SizedBox(height: sizeHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
