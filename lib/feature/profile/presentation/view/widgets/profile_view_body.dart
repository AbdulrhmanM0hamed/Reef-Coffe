import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
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
import 'package:hyper_market/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/cubit/theme_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/view/update_profile/update_name_view.dart';
import 'package:hyper_market/feature/profile/presentation/view/update_profile/update_password_view.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profiel_menu_switch.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_header.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_menu_item.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody(
      {Key? key, required this.userName, required this.userEmail})
      : super(key: key);
  final String userName;
  final String userEmail;

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
              ProfileHeader(userName: userName, userEmail: userEmail),
              const SizedBox(height: 24),
              // بعد ProfileHeader مباشرة

// إضافة خيار تغيير الاسم
              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'تغيير الاسم',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => getIt<ProfileCubit>(),
                        child: const UpdateNameView(),
                      ),
                    ),
                  );
                },
              ),

              ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'تغيير كلمة المرور',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => getIt<ProfileCubit>(),
                        child: const UpdatePasswordView(),
                      ),
                    ),
                  );
                },
              ),

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
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return ProfileMenuSwitch(
                    icon: state.isDark ? Icons.dark_mode : Icons.light_mode,
                    title: state.isDark ? 'الوضع الليلي' : 'الوضع النهاري',
                    value: state.isDark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  );
                },
              ),

              // ProfileMenuSwitch(
              //   icon: Icons.dark_mode_outlined,
              //   title: 'الوضع الليلي',
              //   value: Theme.of(context).brightness == Brightness.dark,
              //   onChanged: (value) {
              //     // Handle theme toggle
              //   },
              // ),
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

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'تأكيد تسجيل الخروج',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size18,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.white
                                    : TColors.darkerGrey,
                          ),
                        ),
                        content: Text(
                          'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.white
                                    : TColors.darkerGrey,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(false), // Cancel
                            child: Text(
                              'إلغاء',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size16,
                                color: TColors.darkerGrey,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(true), // Confirm
                            child: Text(
                              'تأكيد',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true) {
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
                    }
                  },
                  buttonText: 'تسجيل الخروج',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
