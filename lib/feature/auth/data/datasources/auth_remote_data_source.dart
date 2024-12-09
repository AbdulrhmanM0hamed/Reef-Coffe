import 'package:hyper_market/core/error/excptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password, String name);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw  CustomException(message: ' تأكد من البريد الإلكتروني وكلمة المرور');
      }
      
      
      return response.user!;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<User> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );
      
      if (response.user == null) {
        throw   CustomException(message: 'فشل في إنشاء الحساب');
      }
      
      return response.user!;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final response = await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      
      if (!response) {
        throw  CustomException(message: 'فشل في تسجيل الدخول بواسطة Google');
      }
      
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw  CustomException(message: 'فشل في تسجيل الدخول بواسطة Google');
      }
      
      return user;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      final response = await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      
      if (!response) {
        throw  CustomException(message: 'فشل في تسجيل الدخول بواسطة Facebook');
      }
      
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw  CustomException(message: 'فشل في تسجيل الدخول بواسطة Facebook');
      }
      
      return user;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return supabaseClient.auth.currentUser;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
