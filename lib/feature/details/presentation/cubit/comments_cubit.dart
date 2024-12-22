import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  if (isClosed) return; // تحقق من الكيوبت إذا كان مغلقًا

  if (_currentProductId == productId) {
    return; // لا حاجة لجلب البيانات مرة أخرى
  }

  _currentProductId = productId; // تحديث المعرف
  emit(CommentLoading()); // إرسال حالة التحميل

  final result = await commentRepository.getProductComments(productId);
  print('Comments for Product ID: $productId'); // طلب التعليقات

  if (isClosed) return; // تحقق مرة أخرى بعد إكمال الطلب
  
  result.fold(
    (failure) {
      if (!isClosed) {
            print('Failed to load comments: ${failure.message}');

        emit(CommentError(message: failure.message)); // حالة الخطأ
      }
    },
    (comments) {
      if (!isClosed) {
    print('Loaded ${comments.length} comments for Product ID: $productId');

        emit(CommentsLoaded(comments: comments));
         // حالة التحميل الناجح
      }
    },
  );
}




  Future<void> addComment(String productId, String comment) async {
    if (isClosed) return;
    
    emit(CommentLoading());
    
    final result = await commentRepository.addComment(productId, comment);
    
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(CommentError(message: failure.message));
      },
      (_) async {
        if (_currentProductId == productId) {
          final commentsResult = await commentRepository.getProductComments(productId);
          if (!isClosed) {
            commentsResult.fold(
              (failure) => emit(CommentError(message: failure.message)),
              (comments) => emit(CommentsLoaded(comments: comments)),
            );
          }
        }
      },
    );
  }

  Future<void> updateComment(String productId, String comment) async {
    if (isClosed) return;
    
    emit(CommentLoading());
    
    final result = await commentRepository.updateComment(productId, comment);
    
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(CommentError(message: failure.message));
      },
      (updatedComment) async {
        if (_currentProductId == productId) {
          final commentsResult = await commentRepository.getProductComments(productId);
          if (!isClosed) {
            commentsResult.fold(
              (failure) => emit(CommentError(message: failure.message)),
              (comments) => emit(CommentsLoaded(comments: comments)),
            );
          }
        }
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

 void reset() {
    _currentProductId = null;
      emit(CommentLoading());
  }

  @override
  Future<void> close() {
    _currentProductId = null;
    return super.close();
  }
}