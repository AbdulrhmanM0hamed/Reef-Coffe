import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';

class ContentOfCarsoulCart extends StatelessWidget {
  const ContentOfCarsoulCart({
    super.key,
    required this.size,
    required this.offer,
    required this.gradientColors,
  });

  final Size size;
  final SpecialOffer offer;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          if (offer.image2 != null)
            Positioned(
              top: -size.height * 0.06,
              left: -size.width * 0.035,
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: offer.image2!,
                width: size.width * 0.20,
                height: size.height * 0.20,
                errorWidget: (context, url, error) => const SizedBox(),
                
              ),
            ),
          Row(
            children: [
              if (offer.image1 != null)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.009),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: offer.image1!,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => Icon(
                          Icons.image_not_supported,
                          color: Colors.grey.shade400,
                        ),
                        
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(right: size.width * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size18,
                          color: TColors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer.subtitle,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size16,
                          color: TColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
