import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hyper_market/core/services/local_storage/local_storage_service.dart';
import 'package:hyper_market/core/services/notification_service.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/services/shared_preferences.dart';
import 'package:hyper_market/core/services/supabase/supabase_initialize.dart';
import 'package:hyper_market/core/utils/helper/on_genrated_routes.dart';
import 'package:hyper_market/core/utils/theme/theme.dart';
import 'package:hyper_market/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:hyper_market/feature/profile/presentation/cubit/theme_cubit.dart';
import 'package:hyper_market/feature/splash/view/splash_view.dart';
import 'package:hyper_market/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  
  try {
    WidgetsFlutterBinding.ensureInitialized();
     
    await Prefs.init();
    await Prefs.clearInvalidData();

    if (kIsWeb) {
      await FacebookAuth.instance.webAndDesktopInitialize(
        appId: "1318649632135518",
        cookie: true,
        xfbml: true,
        version: "v15.0",
      );
    }

    setupServiceLocator();

    await getIt<SupabaseService>().initialize(
      supabaseUrl: 'https://kizgmgaocdhnarvqtzvf.supabase.co',
      supabaseKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtpemdtZ2FvY2RobmFydnF0enZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMjQ5NjksImV4cCI6MjA0ODkwMDk2OX0.LwosgMdM5ZcZAeVxn3b84lIeO4K6_-l4BsYF5pxxkJg',
    );

    await getIt<LocalStorageService>().init();

    await getIt<NotificationService>().initialize();

    runApp(const MyApp());
  } catch (e) {
    debugPrint('حدث خطأ في التطبيق: $e');
    await Prefs.clearInvalidData();
    runApp(const MyApp());
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
          create: (context) => ThemeCubit(prefs: SharedPreferences.getInstance()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Hyper Market',
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
