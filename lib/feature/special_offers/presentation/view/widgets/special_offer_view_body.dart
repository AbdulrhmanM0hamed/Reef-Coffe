import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/cart/data/models/cart_item_model.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';
import 'package:hyper_market/feature/special_offers/presentation/widgets/offer_quantity_selector.dart';


class SpecialOfferViewBody extends StatefulWidget {
  final SpecialOffer offer;

  const SpecialOfferViewBody({super.key, required this.offer});

  @override
  State<SpecialOfferViewBody> createState() => _SpecialOfferViewBodyState();
}

class _SpecialOfferViewBodyState extends State<SpecialOfferViewBody> {
  int _quantity = 1;

  void _updateQuantity(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // Convert UTC time to local time and ensure 24-hour format
    final DateTime validUntilLocal = widget.offer.validUntil.toLocal();
    final DateTime now = DateTime.now();
    
    // Convert both times to 24-hour format for comparison
    final bool isOfferExpired = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    ).isAfter(DateTime(
      validUntilLocal.year,
      validUntilLocal.month,
      validUntilLocal.day,
      validUntilLocal.hour,
      validUntilLocal.minute,
    ));

    if (isOfferExpired) {
      return Center(
        child: Text(
          'العرض غير متاح حاليا',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size20,
            color: TColors.primary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildOfferImage(size),
          Transform.translate(
            offset: const Offset(0, -40),
            child: Container(
              padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 19, 19, 19)
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndPrice(),
                  const SizedBox(height: 16),
                  _buildDescription(),
                  const SizedBox(height: 16),
                  if (widget.offer.includedItems.isNotEmpty) ...[
                    _buildIncludedItems(),
                    const SizedBox(height: 12),
                  ],
                  if (widget.offer.terms.isNotEmpty) ...[
                    _buildTerms(),
                  ],
                  const SizedBox(height: 24),
                  if (widget.offer.isValid)
                    _buildAddToCartSection()
                  else
                    _buildNotAvailableMessage(),
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferImage(Size size) {
    return SizedBox(
      height: size.height * 0.45,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 3.2 / 3,
            child: Hero(
              tag: 'offer_image_${widget.offer.id}',
              child: CachedNetworkImage(
                imageUrl: widget.offer.image1,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error_outline,
                  color: Colors.grey.shade400,
                  size: 64,
                ),
              ),
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      right: 16,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 19, 19, 19)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
           
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.offer.title,
                style: getBoldStyle(
                  
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.offer.subtitle,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                  color: TColors.darkerGrey,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: TColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${widget.offer.offerPrice} ريال',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل العرض',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.offer.description,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: const Color.fromARGB(255, 129, 125, 125),
          ),
        ),
      ],
    );
  }

  Widget _buildIncludedItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مميزات العرض',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: widget.offer.includedItems
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: TColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: getMediumStyle(
                              color: const Color.fromARGB(255, 112, 110, 110),
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTerms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'شروط العرض',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
          ),
        ),
        const SizedBox(height: 4),
        Column(
          children: widget.offer.terms
              .map(
                (term) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: TColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          term,
                          style: getMediumStyle(
                            color: const Color.fromARGB(255, 112, 110, 110),
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAddToCartSection() {
    final isLoggedIn = !Prefs.getBool(KIsGuestUser) && Prefs.getBool(KIsloginSuccess) == true;

    if (!isLoggedIn) {
      return InkWell(
        onTap: () => Navigator.pushNamed(context, SigninView.routeName),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.login,
                color: TColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'يجب تسجيل الدخول لإضافة المنتج للسلة',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: TColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        OfferQuantitySelector(
          offer: widget.offer,
          onQuantityChanged: _updateQuantity,
        ),
        const SizedBox(height: 16),
        _buildAddToCartButton(),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    final isLoggedIn = !Prefs.getBool(KIsGuestUser) && Prefs.getBool(KIsloginSuccess) == true;
    
    return CustomElevatedButton(
      buttonText: 'اضافة للسلة',
      onPressed: isLoggedIn 
        ? () {
            if (_quantity <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('الرجاء تحديد الكمية'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            final cartItem = CartItem(
              id: widget.offer.id,
              productId: widget.offer.id,
              name: widget.offer.title,
              price: widget.offer.offerPrice,
              image: widget.offer.image1,
              quantity: _quantity,
            );
            getIt<CartCubit>().addItem(cartItem);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم إضافة العرض إلى السلة بنجاح',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: TColors.primary,
              ),
            );
          }
        : () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يجب تسجيل الدخول لإضافة المنتج للسلة'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pushNamed(context, SigninView.routeName);
          },
    );
  }

  Widget _buildNotAvailableMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: TColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'هذا العرض غير متاح حالياً',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: TColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
