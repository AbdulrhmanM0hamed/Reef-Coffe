import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/details/presentation/cubit/comments_cubit.dart';
import 'package:hyper_market/feature/details/presentation/cubit/rating_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/comments_text_widget.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/price_with_additons.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/product_image_section.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/product_info_section.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/rating_section.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/title_with_favorite.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';
import 'package:hyper_market/feature/products/presentation/view/widgets/add_product_snackbar.dart';
import 'package:hyper_market/core/services/service_locator.dart';

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
  late CommentCubit _commentCubit;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _commentCubit = getIt<CommentCubit>();
    _commentCubit.getProductComments(widget.product.id!);
  }

  @override
void didUpdateWidget(DetailsViewBody oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.product.id != widget.product.id) {
    // إعادة تحميل التعليقات عند تغيير المنتج
    _commentCubit.getProductComments(widget.product.id!);
    _commentCubit.getProductComments(widget.product.id!);
  }
}
  @override
  void dispose() {
    _commentCubit.getProductComments(widget.product.id!);
    super.dispose();
  }

  void _updateQuantity(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _commentCubit,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<RatingCubit>()..loadProductRating(widget.product.id!),
          ),
        ],
        child: BlocListener<CommentCubit, CommentState>(
          listener: (context, state) {
            if (state is CommentsLoaded) {
              // تم تحميل التعليقات بنجاح
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              final isSmallScreen = screenWidth < 600;

              return _buildMainContent(context, screenWidth, screenHeight, isSmallScreen);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, double screenWidth, double screenHeight, bool isSmallScreen) {
    return BlocListener<RatingCubit, RatingState>(
      listener: _handleRatingState,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ProductImageSection(
                  imageUrl: widget.product.imageUrl ?? '',
                  productId: widget.product.id!,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  isSmallScreen: isSmallScreen,
                ),
                _buildProductDetails(screenWidth, screenHeight, isSmallScreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(double screenWidth, double screenHeight, bool isSmallScreen) {
    return Transform.translate(
      offset: Offset(0, -screenHeight * 0.05),
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
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              TitleWithFavorite(product: widget.product),
              SizedBox(height: screenHeight * 0.02),
              PriceWithButton_add_min(
                product: widget.product,
                onQuantityChanged: _updateQuantity,
              ),
              RatingSection(
                product: widget.product,
                screenWidth: screenWidth,
                isSmallScreen: isSmallScreen,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildDescription(isSmallScreen),
              SizedBox(height: screenHeight * 0.02),
              _buildCommentsSection(isSmallScreen),
              SizedBox(height: screenHeight * 0.02),
              ProductInfoSection(
                product: widget.product,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                isSmallScreen: isSmallScreen,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildAddToCartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(bool isSmallScreen) {
    return Text(
      widget.product.description,
      style: getSemiBoldStyle(
        fontFamily: FontConstant.cairo,
        fontSize: isSmallScreen ? 14 : 16,
        color: TColors.darkGrey,
      ),
    );
  }

  Widget _buildCommentsSection(bool isSmallScreen) {
    return Row(
      children: [
        Icon(Icons.comment_outlined, size: isSmallScreen ? 20 : 24),
        CommentsTextWidget(widget: widget, isSmallScreen: isSmallScreen),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return CustomElevatedButton(
      onPressed: () => _handleAddToCart(context),
      buttonText: 'اضافة للسلة',
    );
  }

  void _handleAddToCart(BuildContext context) {
    try {
      if (_quantity > 0) {
        final cartItem = CartItem(
          id: widget.product.id!,
          productId: widget.product.id!,
          name: widget.product.name,
          price: widget.product.hasDiscount && widget.product.discountPrice != null
              ? widget.product.discountPrice!
              : widget.product.price,
          image: widget.product.imageUrl ?? '',
          quantity: _quantity,
        );
        context.read<CartCubit>().addItem(cartItem);
        _showSuccessSnackBar(context);
      } else {
        _showQuantityErrorSnackBar(context);
      }
    } catch (e) {
      _showErrorSnackBar(context);
    }
  }

  void _handleRatingState(BuildContext context, RatingState state) {
    if (state is RatingAdded) {
      _showSnackBar('شكراً لتقييمك!', TColors.primary);
    } else if (state is RatingUpdated) {
      _showSnackBar('تم تحديث تقييمك بنجاح!', TColors.primary);
    } else if (state is RatingError) {
      _showSnackBar(state.message, Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AddProductSnackbar(product: widget.product),
        backgroundColor: TColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showQuantityErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('الرجاء تحديد الكمية'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('حدث خطأ أثناء الإضافة إلى السلة'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}