import 'dart:math';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/home/presentation/cubit/special_offers_cubit.dart';
import 'package:hyper_market/feature/home/presentation/cubit/special_offers_state.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/content_carsoul_cart_shimmer.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/dots_carsoul.dart';
import 'package:hyper_market/feature/special_offers/presentation/view/special_offer_view.dart';
import 'package:page_transition/page_transition.dart';

class HomeTopSlider extends StatefulWidget {
  HomeTopSlider({Key? key}) : super(key: key);

  @override
  _HomeTopSliderState createState() => _HomeTopSliderState();
}

class _HomeTopSliderState extends State<HomeTopSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  List<Color> generateSimpleGradient() {
    final random = Random();
    return [
      Color.fromARGB(
        255,
        200 + random.nextInt(56),
        200 + random.nextInt(56),
        200 + random.nextInt(56),
      ),
      Color.fromARGB(
        255,
        180 + random.nextInt(56),
        180 + random.nextInt(56),
        180 + random.nextInt(56),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocBuilder<SpecialOffersCubit, SpecialOffersState>(
      builder: (context, state) {
        if (state is SpecialOffersLoaded) {
          return Column(
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: _getCarouselHeight(size),
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 900),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  viewportFraction: _getViewportFraction(size),
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    _currentPageNotifier.value = index; // تحديث الصفحة الحالية
                  },
                ),
                itemCount: state.offers.length,
                itemBuilder: (context, index, realIndex) {
                  final gradient = generateSimpleGradient();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: SpecialOfferView(offer: state.offers[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // صورة العرض
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: state.offers[index].image1,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          // تدرج شفاف للنص
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          // Offer Badge
                          Positioned(
                            top: 20,
                            left: -30,
                            child: Transform.rotate(
                              angle: -pi / 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${state.offers[index].offerPrice} EGP',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: _getOfferPriceFontSize(size),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // معلومات العرض
                          Positioned(
                            bottom: 15,
                            right: 15,
                            left: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.offers[index].title,
                                  style: getBoldStyle(
                                    color: Colors.white,
                                    fontSize: _getTitleFontSize(size),
                                    fontFamily: FontConstant.cairo,
                                    
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  state.offers[index].subtitle,
                                  style: getMediumStyle(
                                    color: TColors.primary,
                                    fontSize: _getSubtitleFontSize(size),
                                    fontFamily: FontConstant.cairo,
                                
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // زر التفاصيل
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                color: TColors.primary.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: SpecialOfferView(
                                            offer: state.offers[index]),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'التفاصيل',
                                          style: getSemiBoldStyle(
                                            color: Colors.white,
                                            fontSize: _getDetailsFontSize(size),
                                            fontFamily: FontConstant.cairo,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              DotOfCorsoul(
                currentPageNotifier: _currentPageNotifier,
                size: size,
                count: state.offers.length,
              ),

            ],
          );
        } else if (state is SpecialOffersError) {
          return Center(child: Text(state.message));
        } else {
          return OfferCardShimmer(size: size);
        }
      },
    );
  }

  double _getCarouselHeight(Size size) {
    if (size.width < 600) {
      return size.height * 0.17;  // Smaller screens
    } else if (size.width < 1200) {
      return size.height * 0.25;  // Medium screens
    }
    return size.height * 0.28;    // Large screens
  }

  double _getViewportFraction(Size size) {
    if (size.width < 600) {
      return 0.85;  // More visible area on small screens
    } else if (size.width < 1200) {
      return 0.80;  // Balanced view for medium screens
    }
    return 0.75;    // Show more cards on large screens
  }

  double _getHorizontalPadding(Size size) {
    return size.width * 0.05;  // 3% of screen width
  }

  double _getVerticalPadding(Size size) {
    return size.height * 0.01;  // 1% of screen height
  }

  double _getTitleFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size16;
    } else if (size.width < 600) {
      return FontSize.size18;
    } else if (size.width < 1200) {
      return FontSize.size20;
    }
    return FontSize.size22;
  }

  double _getSubtitleFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size14;
    } else if (size.width < 600) {
      return FontSize.size16;
    } else if (size.width < 1200) {
      return FontSize.size18;
    }
    return FontSize.size20;
  }

  double _getOfferPriceFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size12;
    } else if (size.width < 600) {
      return FontSize.size14;
    } else if (size.width < 1200) {
      return FontSize.size16;
    }
    return FontSize.size18;
  }

  double _getDetailsFontSize(Size size) {
    if (size.width < 360) {
      return FontSize.size10;
    } else if (size.width < 600) {
      return FontSize.size12;
    } else if (size.width < 1200) {
      return FontSize.size14;
    }
    return FontSize.size16;
  }
}
