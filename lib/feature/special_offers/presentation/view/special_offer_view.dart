import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/home/domain/entities/special_offer.dart';
import 'package:hyper_market/feature/special_offers/presentation/view/widgets/special_offer_view_body.dart';

class SpecialOfferView extends StatelessWidget {
  final SpecialOffer offer;
  static const String routeName = 'special-offer-details';

  const SpecialOfferView({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: Scaffold(
        body: SpecialOfferViewBody(offer: offer),
      ),
    );
  }
}
