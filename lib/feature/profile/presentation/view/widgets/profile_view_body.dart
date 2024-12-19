import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/constants.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/favorites/presentation/view/favorites_view.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_cubit.dart';
import 'package:hyper_market/feature/orders/presentation/view/orders_view.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profiel_menu_switch.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_header.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_menu_item.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignOutErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthSignedOutState) {
          Navigator.of(context).pushReplacementNamed(SigninView.routeName);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header
              const ProfileHeader(),
              const SizedBox(height: 24),

              // Profile Menu Items
              ProfileMenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'طلباتي',
                onTap: () {
                  final ordersCubit = getIt<OrdersCubit>();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: ordersCubit..getOrders(),
                        child: const OrdersView(),
                      ),
                    ),
                  );
                },
              ),
              ProfileMenuItem(
                icon: Icons.payment_outlined,
                title: 'المدفوعات',
                onTap: () {
                  // Navigate to payments
                },
              ),
              ProfileMenuItem(
                icon: Icons.favorite_border,
                title: 'المفضلة',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => getIt<FavoriteCubit>(),
                        child: const FavoritesView(),
                      ),
                    ),
                  );
                },
              ),
              ProfileMenuSwitch(
                icon: Icons.notifications_outlined,
                title: 'الاشعارات',
                value: true,
                onChanged: (value) {
                  // Handle notifications toggle
                },
              ),
              ProfileMenuSwitch(
                icon: Icons.dark_mode_outlined,
                title: 'الوضع الليلي',
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  // Handle theme toggle
                },
              ),
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'المساعدة',
                onTap: () {
                  // Navigate to help
                },
              ),
              ProfileMenuItem(
                icon: Icons.info_outline,
                title: 'من نحن',
                onTap: () {
                  // Navigate to about
                },
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary.withOpacity(.3),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // Get current user ID before clearing data
                    final userDataJson = await Prefs.getString(KUserData);
                    if (userDataJson != null && userDataJson.isNotEmpty) {
                      try {
                        final userData = json.decode(userDataJson);
                        final user = UserEntity.fromJson(userData);
                        // Clear user specific favorites
                        await Prefs.setString(
                            '${KUserFavorites}${user.id}', '[]');
                      } catch (e) {
                        debugPrint('Error clearing favorites: $e');
                      }
                    }

                    // Clear all user data
                    (
                      Prefs.setBool(KUserLogout, true),
                      Prefs.setBool(KIsloginSuccess, false),
                      Prefs.setString(KUserData, ''),
                      Prefs.setBool(KIsloginSuccess, false),
                    );

                    // Clear user session
                    if (context.mounted) {
                      context.read<SignInCubit>().signOut();
                      Navigator.of(context)
                          .pushReplacementNamed(SigninView.routeName);
                    }
                  },
                  child: Text(
                    'تسجيل الخروج',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? TColors.white
                          : TColors.darkerGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
