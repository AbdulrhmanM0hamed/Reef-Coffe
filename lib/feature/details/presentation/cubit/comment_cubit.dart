import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/details/domain/entities/comment.dart';
import 'package:hyper_market/feature/details/domain/repositories/comment_repository.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository commentRepository;

  CommentCubit({
    required this.commentRepository,
  }) : super(CommentInitial()) {
  }

  Future<void> getProductComments(String productId) async {
    if (state is CommentLoading) return;

    emit(CommentLoading());
    dev.log('Getting comments for product: $productId');
    
    final result = await commentRepository.getProductComments(productId);
    
    result.fold(
      (failure) {
        dev.log('Error getting comments: ${failure.message}');
        emit(CommentError(message: failure.message));
      },
      (comments) {
        dev.log('Got ${comments.length} comments');
        emit(CommentsLoaded(comments: comments));
      },
    );
  }

  Future<void> addComment(String productId, String comment) async {
    emit(CommentLoading());
    dev.log('Adding comment for product: $productId');
    
    final result = await commentRepository.addComment(productId, comment);
    
    result.fold(
      (failure) {
        dev.log('Error adding comment: ${failure.message}');
        emit(CommentError(message: failure.message));
      },
      (_) async {
        dev.log('Comment added successfully');
        final commentsResult = await commentRepository.getProductComments(productId);
        commentsResult.fold(
          (failure) => emit(CommentError(message: failure.message)),
          (comments) => emit(CommentsLoaded(comments: comments)),
        );
      },
    );
  }

  Future<void> updateComment(String productId, String comment) async {
    emit(CommentLoading());
    dev.log('Updating comment for product: $productId');
    
    final result = await commentRepository.updateComment(productId, comment);
    
    result.fold(
      (failure) {
        dev.log('Error updating comment: ${failure.message}');
        emit(CommentError(message: failure.message));
      },
      (updatedComment) async {
        dev.log('Comment updated successfully');
        final commentsResult = await commentRepository.getProductComments(productId);
        commentsResult.fold(
          (failure) => emit(CommentError(message: failure.message)),
          (comments) {
            dev.log('Got updated comments list: ${comments.length} comments');
            emit(CommentsLoaded(comments: comments));
          },
        );
      },
    );
  }

  Future<void> hasUserCommented(String productId) async {
    if (isClosed) return;

    final result = await commentRepository.hasUserCommented(productId);
    result.fold(
      (failure) {
        if (!isClosed) emit(CommentError(message: failure.message));
      },
      (hasCommented) {
        if (!isClosed) emit(UserCommentStatus(hasCommented: hasCommented));
      },
    );
  }
}
