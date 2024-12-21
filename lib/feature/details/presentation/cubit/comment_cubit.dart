import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hyper_market/feature/details/domain/entities/comment.dart';
import 'package:hyper_market/feature/details/domain/repositories/comment_repository.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository commentRepository;
  String? _currentProductId;

  CommentCubit({
    required this.commentRepository,
  }) : super(CommentInitial());

  Future<void> getProductComments(String productId) async {
    if (state is CommentLoading) return;
    if (_currentProductId == productId && state is CommentsLoaded) return;

    emit(CommentLoading());
    _currentProductId = productId;
    
    final result = await commentRepository.getProductComments(productId);
    
    result.fold(
      (failure) {
        emit(CommentError(message: failure.message));
      },
      (comments) {
        emit(CommentsLoaded(comments: comments));
      },
    );
  }

  Future<void> addComment(String productId, String comment) async {
    emit(CommentLoading());
    
    final result = await commentRepository.addComment(productId, comment);
    
    result.fold(
      (failure) {
        emit(CommentError(message: failure.message));
      },
      (_) async {
        await getProductComments(productId);
      },
    );
  }

  Future<void> updateComment(String productId, String comment) async {
    emit(CommentLoading());
    
    final result = await commentRepository.updateComment(productId, comment);
    
    result.fold(
      (failure) {
        emit(CommentError(message: failure.message));
      },
      (_) async {
        await getProductComments(productId);
      },
    );
  }

  Future<void> checkUserComment(String productId) async {
    emit(CommentLoading());
    
    final result = await commentRepository.hasUserCommented(productId);
    
    result.fold(
      (failure) {
        emit(CommentError(message: failure.message));
      },
      (hasCommented) {
        emit(UserCommentStatus(hasCommented: hasCommented));
      },
    );
  }
}
