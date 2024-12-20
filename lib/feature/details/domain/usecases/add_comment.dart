import 'package:dartz/dartz.dart';
import 'package:hyper_market/core/error/sevcice_failure.dart';
import 'package:hyper_market/feature/details/domain/entities/comment.dart';
import 'package:hyper_market/feature/details/domain/repositories/comment_repository.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  @override
  Future<Either<Failure, Comment>> call(AddCommentParams params) async {
    return await repository.addComment(params.productId, params.comment);
  }
}

class AddCommentParams {
  final String productId;
  final String comment;

  AddCommentParams({required this.productId, required this.comment});
}
