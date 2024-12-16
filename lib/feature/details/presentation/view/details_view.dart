import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/details_view_body.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class DetailsView extends StatelessWidget {
  static const String routeName = 'details';
  final Product product;

  const DetailsView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    String? userId;
    final userDataJson = Prefs.getString(KUserData);
    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        final user = UserEntity.fromJson(userDataJson);
        userId = user.id;
      } catch (e) {
        debugPrint('Error parsing user data: $e');
      }
    }

    return BlocProvider(
      create: (context) => getIt<FavoriteCubit>(param1: userId),
      child: SafeArea(
        child: Scaffold(
          body: DetailsViewBody(
            product: product,
          ),
        ),
      ),
    );
  }
}
