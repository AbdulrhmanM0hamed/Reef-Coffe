import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  Future<bool> isEmailRegistered(String email);
  Future<String?> getCurrentUserName();
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
        throw const CustomException(
            message: ' تأكد من البريد الإلكتروني وكلمة المرور');
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
        throw const CustomException(message: 'فشل في إنشاء الحساب');
      }

      return response.user!;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final response = await _googleSignIn();

      if (response.user == null) {
        throw const CustomException(
            message: 'فشل في تسجيل الدخول بواسطة Google');
      }

      return response.user!;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  Future<AuthResponse> _googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId:
            '904000175391-7jj5ffb8bgon6djhjlmjca0gkicg2bp9.apps.googleusercontent.com',
      );

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const CustomException(message: 'تم إلغاء تسجيل الدخول');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw const CustomException(
          message: 'فشل في الحصول على بيانات المصادقة',
        );
      }

      return supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );
    } catch (e) {
      if (e is CustomException) {
        throw e;
      }
      throw CustomException(
          message: 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      final facebookAuth = FacebookAuth.instance;

      final LoginResult result = await facebookAuth.login();

      if (result.status != LoginStatus.success) {
        throw const CustomException(
            message: 'فشل في تسجيل الدخول بواسطة Facebook');
      }

      final accessToken = result.accessToken!;

      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.facebook,
        idToken: accessToken.tokenString,
      );

      final user = response.user;
      if (user == null) {
        throw const CustomException(
            message: 'فشل في تسجيل الدخول بواسطة Facebook');
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

  @override
  Future<bool> isEmailRegistered(String email) async {
    try {
      final response = await supabaseClient.rpc(
        'check_email_exists',
        params: {'email_to_check': email},
      );
      return response as bool;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<String?> getCurrentUserName() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user != null) {
        return user.userMetadata!['name'] as String?;
      }

      return null;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
