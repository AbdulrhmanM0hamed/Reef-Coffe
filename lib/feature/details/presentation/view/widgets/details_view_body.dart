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

class DetailsViewBody extends StatelessWidget {
  final Product product;

  const DetailsViewBody({
    Key? key,
    required this.product,
  }) : super(key: key);

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
              tag: 'product_image_${product.id}_list',
              child: Container(
                width: double.infinity,
                height: sizeHeight * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl ?? '',
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
            TitleWithFavorite(product: product),
            SizedBox(height: sizeHeight * 0.01),
            PriceWithButton_add_min(product: product),
            SizedBox(height: sizeHeight * 0.015),
            ReviewsWidget(product: product),
            SizedBox(height: sizeHeight * 0.015),
            Text(
              product.description!,
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
                          mainText: product.expiryName!,
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
                                  '${product.expiryNumber.toInt()}',
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
                          mainText: product.isOrganic ? 'طبيعي' : 'غير طبيعي',
                          subText:
                              product.isOrganic ? '100% طبيعي' : 'منتج مصنع',
                          iconInfo: SvgPicture.asset(
                            'assets/images/lotus.svg',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        buildInfoCard(
                          mainText: '${product.caloriesPer100g}',
                          subText: 'سعرة حرارية',
                          extraText: '100 جرام',
                          iconInfo: SvgPicture.asset(
                            'assets/images/calory.svg',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        buildInfoCard(
                          mainText: '${product.rating}',
                          subText: 'تقييم',
                          extraText: '${product.ratingCount} مراجعة',
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
                final cartItem = CartItem(
                  id: product.id!,
                  productId: product.id!,
                  name: product.name,
                  price: product.discountPrice == 0.0
                      ? product.price
                      : product.discountPrice,
                  image: product.imageUrl!,
                );

                context.read<CartCubit>().addItem(cartItem);
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
