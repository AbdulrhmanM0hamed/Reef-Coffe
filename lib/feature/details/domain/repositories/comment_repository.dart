import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, Comment>> addComment(String productId, String comment);
  Future<Either<Failure, List<Comment>>> getProductComments(String productId);
  Future<Either<Failure, bool>> hasUserCommented(String productId);
  Future<Either<Failure, Comment>> updateComment(String productId, String comment);
}
