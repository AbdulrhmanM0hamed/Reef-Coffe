import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hyper_market/core/error/excptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(
      String email, String password, String name, String phoneNumber);
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  // Future<User> signInWithFacebook();
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<void> resetPassword(String email);
  Future<bool> isEmailRegistered(String email);
  Future<String?> getCurrentUserName();
  Future<String?> getCurrentUserEmail();
  Future<String?> getUserPhoneNumber(String email);
  // Future<void> verifyPhoneNumber(String phoneNumber);
  // Future<void> sendOTP(String phoneNumber);
  // Future<bool> verifyOTP(String phoneNumber, String otp);


  Future<void> sendResetCode(String email);
  Future<void> verifyResetCode(String email, String code);
  Future<void> resetPasswordWithCode(String email, String newPassword);
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
        throw const CustomException(message: 'فشل في تسجيل الدخول');
      }

      return response.user!;
    } catch (e) {
      if (e is AuthException) {
        String message = e.message;
        if (e.message.contains("Invalid login credentials")) {
          message = "البريد الإلكتروني أو كلمة المرور غير صحيحة";
        } else if (e.message.contains("Email not confirmed")) {
          message = "يرجى تأكيد البريد الإلكتروني أولاً";
        } else if (e.message.contains("Too many requests")) {
          message = "محاولات كثيرة، يرجى المحاولة بعد قليل";
        }
        throw CustomException(message: message);
      }
      throw const CustomException(message: 'حدث خطأ في تسجيل الدخول');
    }
  }




  @override

  Future<User> signUpWithEmail(
  String email,
  String password,
  String name,
  String phoneNumber,
) async {
  try {
    
    // Create auth user
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('حدث خطأ في إنشاء الحساب');
    }

    
    // Create profile
    try {
      await supabaseClient.from('profiles').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
      });
    } catch (e) {
      throw e;
    }

    return response.user!;
  } on AuthException catch (e) {
    debugPrint('AuthException occurred: ${e.message}');
    throw AuthException(e.message);
  } catch (e) {
    throw const AuthException('حدث خطأ في إنشاء الحساب');
  }
}




@override
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId: '904000175391-0ijobvfb8vhn3trgi78d4902n4qfd7o6.apps.googleusercontent.com',  // Web Client ID
      );

      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const CustomException(message: 'تم إلغاء تسجيل الدخول');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw const CustomException(message: 'لم يتم العثور على Access Token');
      }
      if (idToken == null) {
        throw const CustomException(message: 'لم يتم العثور على ID Token');
      }

      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw const CustomException(message: 'فشل في تسجيل الدخول بواسطة جوجل');
      }

      // تحقق من وجود البروفايل
      final profile = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (profile == null) {
        await supabaseClient.from('profiles').insert({
          'id': response.user!.id,
          'name': googleUser.displayName,
          'email': googleUser.email,
          "provider": response.user!.appMetadata['provider'],
        });
      }

      return response.user!;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }




  @override
  Future<User> signInWithApple() async {
    try {
      final response = await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'hypermarket://callback',
      );

      if (!response) {
        throw const CustomException(message: 'فشل في تسجيل الدخول باستخدام Apple');
      }

      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw const CustomException(message: 'فشل في تسجيل الدخول باستخدام Apple');
      }

      return user;
    } catch (e) {
      if (e is AuthException) {
        String message = e.message;
        if (e.message.contains("User cancelled")) {
          message = "تم إلغاء تسجيل الدخول";
        }
        throw CustomException(message: message);
      }
      throw const CustomException(message: 'فشل في تسجيل الدخول باستخدام Apple');
    }
  }

  // @override
  // Future<User> signInWithFacebook() async {
  //   try {
  //     final facebookAuth = FacebookAuth.instance;

  //     final LoginResult result = await facebookAuth.login();

  //     if (result.status != LoginStatus.success) {
  //       throw const CustomException(
  //           message: 'فشل في تسجيل الدخول بواسطة Facebook');
  //     }

  //     final accessToken = result.accessToken!;

  //     final response = await supabaseClient.auth.signInWithIdToken(
  //       provider: OAuthProvider.facebook,
  //       idToken: accessToken.tokenString,
  //     );

  //     final user = response.user;
  //     if (user == null) {
  //       throw const CustomException(
  //           message: 'فشل في تسجيل الدخول بواسطة Facebook');
  //     }

  //     return user;
  //   } catch (e) {
  //     throw CustomException(message: e.toString());
  //   }
  // }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      if (e is AuthException) {
        String message = e.message;
        if (e.message.contains("User not found")) {
          message = "لم يتم تسجيل الدخول";
        } else if (e.message.contains("Session expired")) {
          message = "انتهت صلاحية الجلسة";
        }
        throw CustomException(message: message);
      }
      throw const CustomException(message: 'حدث خطأ في تسجيل الخروج');
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
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: 'hypermarket://reset-password', 
      );
    } catch (e) {
      if (e is AuthException) {
        String message = e.message;
        if (e.message.contains("Email not found")) {
          message = "البريد الإلكتروني غير مسجل";
        } else if (e.message.contains("Too many requests")) {
          message = "محاولات كثيرة، يرجى المحاولة بعد قليل";
        }
        throw CustomException(message: message);
      }
      throw const CustomException(message: 'حدث خطأ في إعادة تعيين كلمة المرور');
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
        final response = await supabaseClient
            .from('profiles')
            .select('name')
            .eq('id', user.id)
            .single();
        
        return response['name'] as String?;
      }

      return null;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<String?> getUserPhoneNumber(String email) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('phone_number')
          .eq('email', email)
          .single();

      return response['phone_number'] as String?;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  // @override
  // Future<void> verifyPhoneNumber(String phoneNumber) async {
  //   try {
  //     // Here we'll integrate with your SMS service provider
  //     final response = await supabaseClient
  //         .from('profiles')
  //         .select('phone_number')
  //         .eq('phone_number', phoneNumber)
  //         .single();

  //     if (response == null) {
  //       throw const CustomException(message: 'رقم الهاتف غير مسجل');
  //     }

  //     // Generate OTP (6 digits)
  //     final otp = (100000 + Random().nextInt(900000)).toString();

  //     // Store OTP in Supabase with expiration time (5 minutes)
  //     await supabaseClient.from('otp_verification').insert({
  //       'phone_number': phoneNumber,
  //       'otp': otp,
  //       'expires_at':
  //           DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
  //     });

  //     // Here you would integrate with an SMS service to send the OTP
  //     // For now, we'll just print it (in production, you'd use a real SMS service)
  //     debugPrint('OTP for $phoneNumber: $otp');
  //   } catch (e) {
  //     throw CustomException(message: e.toString());
  //   }
  // }

  // @override
  // Future<void> sendOTP(String phoneNumber) async {
  //   try {
  //     // Here we'll integrate with your SMS service provider
  //     final response = await supabaseClient
  //         .from('profiles')
  //         .select('phone_number')
  //         .eq('phone_number', phoneNumber)
  //         .single();

  //     if (response == null) {
  //       throw const CustomException(message: 'رقم الهاتف غير مسجل');
  //     }

  //     // Generate OTP (6 digits)
  //     final otp = (100000 + Random().nextInt(900000)).toString();

  //     // Store OTP in Supabase with expiration time (5 minutes)
  //     await supabaseClient.from('otp_verification').insert({
  //       'phone_number': phoneNumber,
  //       'otp': otp,
  //       'expires_at':
  //           DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
  //     });

  //     // Here you would integrate with an SMS service to send the OTP
  //     // For now, we'll just print it (in production, you'd use a real SMS service)
  //     debugPrint('OTP for $phoneNumber: $otp');
  //   } catch (e) {
  //     throw CustomException(message: e.toString());
  //   }
  // }

  // @override
  // Future<bool> verifyOTP(String phoneNumber, String otp) async {
  //   try {
  //     final response = await supabaseClient
  //         .from('otp_verification')
  //         .select()
  //         .eq('phone_number', phoneNumber)
  //         .eq('otp', otp)
  //         .gte('expires_at', DateTime.now().toIso8601String())
  //         .single();

  //     if (response == null) {
  //       throw const CustomException(
  //           message: 'رمز التحقق غير صحيح أو منتهي الصلاحية');
  //     }

  //     // Delete used OTP
  //     await supabaseClient
  //         .from('otp_verification')
  //         .delete()
  //         .eq('phone_number', phoneNumber);

  //     return true;
  //   } catch (e) {
  //     throw CustomException(message: e.toString());
  //   }
  // }

  @override
  Future<void> sendResetCode(String email) async {
    try {
      final response = await supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: null, 
      );
    } catch (e) {
      if (e is AuthException) {
        String message = e.message;
        if (e.message.contains("For security purposes")) {
          final RegExp regex = RegExp(r'after (\d+) seconds');
          final match = regex.firstMatch(e.message);
          final seconds = match?.group(1) ?? "14";
          message = "لأسباب أمنية، يرجى الانتظار $seconds ثانية قبل إعادة طلب الكود";
        } else if (e.message.contains("Email not found")) {
          message = "البريد الإلكتروني غير مسجل";
        } else if (e.message.contains("Too many requests")) {
          message = "محاولات كثيرة، يرجى المحاولة بعد قليل";
        }
        throw CustomException(message: message);
      }
      throw const CustomException(message: 'حدث خطأ في إرسال كود التحقق');
    }
  }

  @override
  Future<void> verifyResetCode(String email, String code) async {
    try {
      final response = await supabaseClient.auth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.recovery,
      );
    } catch (e) {
      if (e is AuthException) {
        String message = e.message;
        if (e.message.contains("Invalid otp")) {
          message = "كود التحقق غير صحيح";
        } else if (e.message.contains("Token has expired")) {
          message = "كود التحقق غير صحيح";
        } else if (e.message.contains("Too many attempts")) {
          message = "محاولات كثيرة، يرجى طلب كود جديد";
        }
        throw CustomException(message: message);
      }
      throw const CustomException(message: 'كود التحقق غير صحيح');
    }
  }

  @override
  Future<void> resetPasswordWithCode(String email, String newPassword) async {
    try {
      final response = await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      if (e is AuthException) {
        String message = e.message;
        if (e.message.contains("New password should be different")) {
          message = "كلمة المرور الجديدة يجب أن تكون مختلفة عن كلمة المرور القديمة";
        } else if (e.message.contains("Password should be at least 6 characters")) {
          message = "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
        } else if (e.message.contains("Token has expired")) {
          message = "انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول";
        }
        throw CustomException(message: message);
      }
      throw const CustomException(message: 'حدث خطأ في تحديث كلمة المرور');
    }
  }
  
  @override
  Future<String?> getCurrentUserEmail() async {
       try {
      final user = supabaseClient.auth.currentUser;

      if (user != null) {
        final response = await supabaseClient
            .from('profiles')
            .select('email')
            .eq('id', user.id)
            .single();
        
        return response['email'] as String?;
      }

      return null;
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
