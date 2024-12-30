import 'package:hyper_market/core/error/excptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateName(String newName);
  Future<void> updatePassword(String currentPassword, String newPassword);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      // التحقق من كلمة المرور الحالية
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw const CustomException(message: 'المستخدم غير مسجل الدخول');
      }

      // محاولة تسجيل الدخول بكلمة المرور الحالية للتحقق
      try {
        await supabaseClient.auth.signInWithPassword(
          email: user.email!,
          password: currentPassword,
        );
      } catch (e) {
        throw const CustomException(message: 'كلمة المرور الحالية غير صحيحة');
      }

      // تحديث كلمة المرور
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw CustomException(message: e.message);
    } catch (e) {
      throw const CustomException(message: 'كلمة المرور الحالية غير صحيحة');
    }
  }

  @override
  Future<void> updateName(String newName) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw const CustomException(message: 'المستخدم غير مسجل الدخول');
      }

      // تحديث الاسم في user metadata
      final response = await supabaseClient.auth.updateUser(
        UserAttributes(
          data: {'name': newName},
        ),
      );

      if (response.user == null) {
        throw const CustomException(message: 'فشل في تحديث الاسم');
      }

      // تحديث الاسم في جدول profiles
      await supabaseClient
          .from('profiles')
          .update({'name': newName})
          .eq('id', user.id);

    } on AuthException catch (e) {
      throw CustomException(message: e.message);
    } catch (e) {
      throw const CustomException(message: 'حدث خطأ غير متوقع');
    }
  }
}