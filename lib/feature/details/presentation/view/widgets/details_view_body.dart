import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/details/presentation/cubit/rating_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/info_section.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/price_with_additons.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/rating_dialog.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/title_with_favorite.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/add_product_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _supabase = Supabase.instance.client;

  void _updateQuantity(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }

  void _showRatingDialog(BuildContext context) {
    final dialogContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RatingDialog(
        onRatingSubmitted: (rating) {
          Navigator.pop(context);
          dialogContext.read<RatingCubit>().submitOrUpdateRating(
                widget.product.id!,
                rating.toInt(),
              );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<RatingCubit>().loadProductRating(widget.product.id!);
  }

  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;

    return BlocListener<RatingCubit, RatingState>(
      listener: (context, state) {
        if (state is RatingAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'شكراً لتقييمك!',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              backgroundColor: TColors.primary,
            ),
          );
        } else if (state is RatingUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تحديث تقييمك بنجاح!',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              backgroundColor: TColors.primary,
            ),
          );
        } else if (state is RatingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Stack(
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
                                borderRadius: BorderRadius.circular(16)),
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
                  offset: const Offset(0, -40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 19, 19, 19)
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: sizeWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          TitleWithFavorite(product: widget.product),
                          const SizedBox(height: 16),
                          SizedBox(height: sizeHeight * 0.01),
                          PriceWithButton_add_min(
                            product: widget.product,
                            onQuantityChanged: _updateQuantity,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 24),
                              const SizedBox(width: 8),
                              BlocBuilder<RatingCubit, RatingState>(
                                builder: (context, state) {
                                  if (state is ProductRatingLoaded) {
                                    return Text(
                                      '${state.rating.toStringAsFixed(1)}',
                                      style: getBoldStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: 16,
                                      ),
                                    );
                                  }
                                  return Text(
                                    '${widget.product.rating}',
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              BlocBuilder<RatingCubit, RatingState>(
                                builder: (context, state) {
                                  if (state is ProductRatingLoaded) {
                                    return Text(
                                      '(${state.count} تقييم)',
                                      style: getMediumStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: 14,
                                        color: TColors.darkGrey,
                                      ),
                                    );
                                  }
                                  return Text(
                                    '(${widget.product.ratingCount} تقييم)',
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: 14,
                                      color: TColors.darkGrey,
                                    ),
                                  );
                                },
                              ),
                              TextButton(
                                onPressed: () => _showRatingDialog(context),
                                child: Text(
                                  'قيم المنتج',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: sizeWidth * 0.041,
                                    color: TColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sizeHeight * 0.010),
                          Text(
                            widget.product.description,
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 1.8,
                                    children: [
                                      buildInfoCard(
                                        mainText:
                                            '${widget.product.caloriesPer100g}',
                                        subText: 'سعرة حرارية',
                                        extraText: 'لكل وجبة',
                                        iconInfo: SvgPicture.asset(
                                          'assets/images/calory.svg',
                                          width: 40,
                                          height: 40,
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
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                      buildInfoCard(
                                        mainText: widget.product.expiryName,
                                        subText: 'وقت التحضير',
                                        iconInfo: SvgPicture.asset(
                                          'assets/images/cooking-time.svg',
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                      buildInfoCard(
                                        mainText: '${10}',
                                        subText: 'جرام',
                                        extraText: 'وزن الوجبة',
                                        iconInfo: SvgPicture.asset(
                                          'assets/images/weight.svg',
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: sizeHeight * 0.018),
                          CustomElevatedButton(
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
                                    content: AddProductSnackbar(
                                        product: widget.product),
                                    backgroundColor: TColors.primary,
                                    duration: const Duration(seconds: 1),
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
                            buttonText: 'اضافة للسلة',
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
      ),
    );
  }
}
