
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hyper_market/core/services/local_storage/local_storage_service.dart';
import 'package:hyper_market/core/services/notification_service.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
import 'package:hyper_market/core/utils/helper/on_genrated_routes.dart';
import 'package:hyper_market/core/utils/theme/theme.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/notifications/data/repositories/notification_repository_impl.dart';
import 'package:hyper_market/feature/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/cubit/theme_cubit.dart';
import 'package:hyper_market/feature/splash/view/splash_view.dart';
import 'package:hyper_market/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
 

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

    await Prefs.init();
    await Prefs.clearInvalidData();

    setupServiceLocator();

    await getIt<SupabaseService>().initialize(
      supabaseUrl: dotenv.env['SUPABASE_URL']!,
      supabaseKey: dotenv.env['SUPABASE_KEY']!,
    );

    await getIt<LocalStorageService>().init();

    await NotificationService.init();

    final notificationRepo = NotificationRepositoryImpl();
    notificationRepo.listenToOrderChanges();

    runApp(const MyApp());
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<CartCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              ThemeCubit(prefs: SharedPreferences.getInstance()),
        ),
        BlocProvider<NotificationsCubit>(
          create: (context) => NotificationsCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'ريف القهوة',
            debugShowCheckedModeBanner: false,
            theme: state.isDark ? TAppTheme.darkTheme : TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: const Locale('ar'),
            onGenerateRoute: onGenratedRoutes,
            initialRoute: SplashView.routeName,
          );
        },
      ),
    );
  }
}
