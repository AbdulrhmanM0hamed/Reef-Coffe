import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/cart/presentation/pages/cart_page.dart';
import 'package:hyper_market/feature/categories/presentation/view/categories_view.dart';
import 'package:hyper_market/feature/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:hyper_market/feature/home/presentation/cubit/user_cubit.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/bottom_nav_bar.dart';
import 'package:hyper_market/feature/home/presentation/view/widgets/home_view_body.dart';
import 'package:hyper_market/feature/profile/presentation/view/profile_view.dart';

class HomeView extends StatefulWidget {
  static const String routeName = "home";

  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; // متغير لحفظ الفهرس الحالي

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider.value(value: getIt<FavoriteCubit>()),
        BlocProvider(
          create: (context) => UserCubit(authRepository: getIt())..getCurrentUserName(),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CustomBottomNavBar(
            pageController: _pageController,
            currentIndex: _currentIndex,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is UserLoadedState) {
                    return HomeViewBody(userName: state.name);
                  }
                  return HomeViewBody(userName: 'زائر');
                },
              ),
              CategoriesViewApp(),
              CartPage(),
              ProfileView()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
