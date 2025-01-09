import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/details/presentation/controller/rating_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/details_view_body.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/details/presentation/controller/comments_cubit.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class DetailsView extends StatelessWidget {
  static const String routeName = '/details';
  final Product product;
  final String heroTag;

  const DetailsView({
    Key? key,
    required this.product,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>.value(value: getIt<CartCubit>()),
        BlocProvider<FavoriteCubit>.value(value: getIt<FavoriteCubit>()),
        BlocProvider<RatingCubit>(
          create: (context) => getIt<RatingCubit>(),
        ),
        BlocProvider(create: (context) => getIt<CommentCubit>()),
      ],
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: DetailsViewBody(
            product: product,
            heroTag: heroTag,
          ),
        ),
      ),
    );
  }
}
