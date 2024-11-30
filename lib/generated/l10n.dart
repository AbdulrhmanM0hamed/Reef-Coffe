// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S? current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current!;
    });
  } 

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `كلمة المرور`
  String get password {
    return Intl.message(
      'كلمة المرور',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `start`
  String get start {
    return Intl.message(
      'start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get login {
    return Intl.message(
      'تسجيل الدخول',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل جديد`
  String get signup {
    return Intl.message(
      'تسجيل جديد',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل خروج`
  String get logout {
    return Intl.message(
      'تسجيل خروج',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get home {
    return Intl.message(
      'الرئيسية',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `الملف الشخصي`
  String get profile {
    return Intl.message(
      'الملف الشخصي',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `الاعدادات`
  String get settings {
    return Intl.message(
      'الاعدادات',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `البحث`
  String get search {
    return Intl.message(
      'البحث',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `عن التطبيق`
  String get about {
    return Intl.message(
      'عن التطبيق',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `اتصل بنا`
  String get contact {
    return Intl.message(
      'اتصل بنا',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `اللغة`
  String get language {
    return Intl.message(
      'اللغة',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `مرحبا بك في `
  String get welcome {
    return Intl.message(
      'مرحبا بك في ',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `اكتشف تجربة تسوق فريدة مع FruitHUB, استكشف مجموعتنا الواسعة من الفواكه الطازجة الممتازة واحصل على افضل العروض والجودة العالية`
  String get Subtitle1 {
    return Intl.message(
      'اكتشف تجربة تسوق فريدة مع FruitHUB, استكشف مجموعتنا الواسعة من الفواكه الطازجة الممتازة واحصل على افضل العروض والجودة العالية',
      name: 'Subtitle1',
      desc: '',
      args: [],
    );
  }

  /// ` نقدم لك أفضل الفواكه المختارة بعناية, اطلع على التفاصيل والصور والتقييمات لتتأكد من اختيار الفاكهة المثالية`
  String get Subtitle2 {
    return Intl.message(
      ' نقدم لك أفضل الفواكه المختارة بعناية, اطلع على التفاصيل والصور والتقييمات لتتأكد من اختيار الفاكهة المثالية',
      name: 'Subtitle2',
      desc: '',
      args: [],
    );
  }

  /// `ابحث وتسوق بسهولة`
  String get searchMarketing {
    return Intl.message(
      'ابحث وتسوق بسهولة',
      name: 'searchMarketing',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get loginTitle {
    return Intl.message(
      'تسجيل الدخول',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `البريد الالكتروني`
  String get email {
    return Intl.message(
      'البريد الالكتروني',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `هل نسيت كلمة المرور ؟`
  String get forgotPassword {
    return Intl.message(
      'هل نسيت كلمة المرور ؟',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `لا تمتلك حساب ؟`
  String get noAccount {
    return Intl.message(
      'لا تمتلك حساب ؟',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `سجل الان`
  String get signUpNow {
    return Intl.message(
      'سجل الان',
      name: 'signUpNow',
      desc: '',
      args: [],
    );
  }

  /// `أو`
  String get or {
    return Intl.message(
      'أو',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل بواسطة Google`
  String get loginWithGoogle {
    return Intl.message(
      'تسجيل بواسطة Google',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل بواسطة Facebook`
  String get loginWithFacebook {
    return Intl.message(
      'تسجيل بواسطة Facebook',
      name: 'loginWithFacebook',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل بواسطة Apple`
  String get loginWithApple {
    return Intl.message(
      'تسجيل بواسطة Apple',
      name: 'loginWithApple',
      desc: '',
      args: [],
    );
  }

  /// `الاسم الكامل`
  String get fullName {
    return Intl.message(
      'الاسم الكامل',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}