import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final Future<SharedPreferences> prefs;
  static const String _themeKey = 'isDark';
  late SharedPreferences _prefsInstance;

  ThemeCubit({required this.prefs}) : super(ThemeState(isDark: false)) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefsInstance = await prefs;
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = _prefsInstance.getBool(_themeKey) ?? false;
    emit(ThemeState(isDark: isDark));
  }

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDark;
    await _prefsInstance.setBool(_themeKey, newIsDark);
    emit(ThemeState(isDark: newIsDark));
  }
}
