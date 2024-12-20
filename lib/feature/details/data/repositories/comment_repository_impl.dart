import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/data/models/comment_model.dart';
import 'package:hyper_market/feature/details/domain/entities/comment.dart';
import 'package:hyper_market/feature/details/domain/repositories/comment_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepositoryImpl implements CommentRepository {
  final SupabaseClient supabaseClient;

  CommentRepositoryImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, List<Comment>>> getProductComments(String productId) async {
    try {
      dev.log('Getting comments for product: $productId');
      
      // أولاً نجلب التعليقات للمنتج المحدد
      final response = await supabaseClient
          .from('reviews_v2')
          .select('id, product_id, user_id, user_name, comment, created_at, updated_at')
          .eq('product_id', productId)  // التأكد من جلب تعليقات المنتج المحدد فقط
          .order('created_at', ascending: false);
      
      dev.log('Reviews response: $response');
      
      if (response == null || (response as List).isEmpty) {
        dev.log('No comments found for product: $productId');
        return const Right([]);
      }

      // نجلب بيانات المستخدمين
      final comments = await Future.wait(
        (response as List).map((review) async {
          try {
            final userId = review['user_id'] as String;
            final userProfile = await supabaseClient
                .from('profiles')
                .select('name')
                .eq('id', userId)
                .single();
            
            return CommentModel.fromJson({
              ...review,
              'user_name': userProfile['name'] as String? ?? 'مستخدم',
            });
          } catch (e) {
            dev.log('Error getting user profile: $e');
            return CommentModel.fromJson({
              ...review,
              'user_name': 'مستخدم',
            });
          }
        }),
      );
      
      dev.log('Found ${comments.length} comments for product: $productId');
      return Right(comments);
    } catch (e) {
      dev.log('Error getting comments: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(String productId, String comment) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        return Left(ServerFailure(message: 'يجب تسجيل الدخول أولاً'));
      }

      dev.log('Adding comment for user: ${user.id} and product: $productId');

      final response = await supabaseClient.from('reviews_v2').insert({
        'product_id': productId,
        'user_id': user.id,
        'user_name': user.userMetadata?['name'] ?? 'مستخدم',
        'comment': comment,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).select('id, product_id, user_id, user_name, comment, created_at, updated_at').single();

      dev.log('Comment added successfully: $response');
      return Right(CommentModel.fromJson(response));
    } catch (e) {
      dev.log('Error adding comment: $e');
      return Left(ServerFailure(message: 'فشل في إضافة التعليق'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserCommented(String productId) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      dev.log('Checking comments for user: $userId and product: $productId');
      
      final response = await supabaseClient
          .from('reviews_v2')
          .select('id')
          .eq('product_id', productId)  // التأكد من المنتج المحدد
          .eq('user_id', userId)
          .maybeSingle();
      
      final hasCommented = response != null;
      dev.log('User has commented: $hasCommented');
      return Right(hasCommented);
    } catch (e) {
      dev.log('Error checking comment: $e');
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, Comment>> updateComment(String productId, String comment) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      dev.log('Updating comment for user: $userId and product: $productId');

      // أولاً نجد التعليق الحالي
      final currentComment = await supabaseClient
          .from('reviews_v2')
          .select()
          .eq('product_id', productId)
          .eq('user_id', userId)
          .maybeSingle();

      if (currentComment == null) {
        dev.log('Comment not found');
        return Left(ServerFailure(message: 'لم يتم العثور على التعليق'));
      }

      dev.log('Found current comment: $currentComment');

      // تحديث التعليق
      final updates = {
        'comment': comment,
        'updated_at': DateTime.now().toIso8601String(),
      };

      dev.log('Updating comment with data: $updates');

      // تنفيذ التحديث وجلب البيانات المحدثة
      final result = await supabaseClient
          .from('reviews_v2')
          .update(updates)
          .eq('id', currentComment['id'])
          .select()
          .single();

      dev.log('Comment updated successfully: $result');
      return Right(CommentModel.fromJson(result));

    } catch (e) {
      dev.log('Error updating comment: $e');
      if (e is PostgrestException) {
        dev.log('PostgrestException: ${e.message}, Code: ${e.code}, Details: ${e.details}');
        return Left(ServerFailure(message: e.message));
      }
      return Left(ServerFailure(message: 'فشل في تحديث التعليق'));
    }
  }

}
