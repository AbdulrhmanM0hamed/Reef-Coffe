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
import 'package:hyper_market/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/favorites/presentation/view/favorites_view.dart';
import 'package:hyper_market/feature/home/presentation/cubit/user_cubit.dart';
import 'package:hyper_market/feature/orders/presentation/cubit/orders_cubit.dart';
import 'package:hyper_market/feature/orders/presentation/view/orders_view.dart';
import 'package:hyper_market/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/cubit/theme_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/view/update_profile/update_name_view.dart';
import 'package:hyper_market/feature/profile/presentation/view/update_profile/update_password_view.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profiel_menu_switch.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_header.dart';
import 'package:hyper_market/feature/profile/presentation/view/widgets/profile_menu_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody(
      {Key? key, required this.userName, required this.userEmail})
      : super(key: key);
  final String userName;
  final String userEmail;

  Future<void> _launchLinkedIn() async {
    final Uri url =
        Uri.parse('https://www.linkedin.com/in/abdulrhman-mohamed-/');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'من نحن',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: TColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ريف القهوة هو مطعم رائد في تقديم الوجبات الصحية والمكملات الغذائية عالية الجودة، نهتم بصحتك ولياقتك ',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'تطوير',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: TColors.primary,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchLinkedIn();
                  },
                  child: Text(
                    'Abdulrhman Mohamed',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _launchLinkedIn,
                  child: SvgPicture.asset(
                    'assets/images/linked.svg',
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'الإصدار 1.0.0',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: TColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'المساعدة',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: TColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection('للتواصل معنا:', 'reefcafe58@gmail.com'),
            const SizedBox(height: 10),
            _buildHelpSection('رقم الهاتف:', '5171 511 56 966+'),
            const SizedBox(height: 10),
            _buildHelpSection('رقم الهاتف:', '0901 141 056'),
            const SizedBox(height: 10),
            _buildHelpSection('ساعات العمل:', '8 صباحاً -10 مساءً'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: TColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: TColors.primary,
          ),
        ),
        Text(
          content,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuestUser = Prefs.getBool(KIsGuestUser) == true;
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),

              // عرض هذه العناصر فقط للمستخدمين المسجلين
              if (!isGuestUser) ...[
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
              ],

              // العناصر المتاحة للجميع
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

              _buildProfileMenuItem(
                title: 'المساعدة',
                icon: Icons.help_outline,
                onTap: () => _showHelpDialog(context),
              ),

              _buildProfileMenuItem(
                title: 'من نحن',
                icon: Icons.info_outline,
                onTap: () => _showAboutDialog(context),
              ),
              const SizedBox(height: 16),
              // زر تسجيل الدخول للزائر أو تسجيل الخروج للمستخدم المسجل
              _buildAuthButton(context, isGuestUser),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context, bool isGuestUser) {
    return CustomElevatedButton(
      buttonText: isGuestUser ? 'تسجيل الدخول' : 'تسجيل الخروج',
      onPressed: () async {
        if (isGuestUser) {
          Navigator.pushReplacementNamed(context, SigninView.routeName);
        } else {
          try {
            // مسح محتويات السلة أولاً
            final cartCubit = getIt<CartCubit>();
            cartCubit.clearCart();

            // ثم تسجيل الخروج
            await getIt<AuthRemoteDataSource>().signOut();

            // تحديث حالة المستخدم
            await Prefs.setBool(KIsGuestUser, false);
            await Prefs.setBool(KIsloginSuccess, false);
            await Prefs.remove(KUserName);
            await Prefs.remove(KUserEmail);

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                SigninView.routeName,
                (route) => false,
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('حدث خطأ أثناء تسجيل الخروج'),
                  backgroundColor: TColors.error,
                ),
              );
            }
          }
        }
      },
    );
  }

  Widget _buildProfileHeader() {
    return ProfileHeader(userName: userName, userEmail: userEmail);
  }

  Widget _buildProfileMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ProfileMenuItem(
      icon: icon,
      title: title,
      onTap: onTap,
    );
  }
}
