part of 'comment_cubit.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentError extends CommentState {
  final String message;

  const CommentError({required this.message});

  @override
  List<Object> get props => [message];
}

class CommentAdded extends CommentState {
  final Comment comment;

  const CommentAdded({required this.comment});

  @override
  List<Object> get props => [comment];
}

class CommentUpdated extends CommentState {
  final Comment comment;

  const CommentUpdated({required this.comment});

  @override
  List<Object> get props => [comment];
}

class CommentsLoaded extends CommentState {
  final List<Comment> comments;

  const CommentsLoaded({required this.comments});

  @override
  List<Object> get props => [comments];
}

class UserCommentStatus extends CommentState {
  final bool hasCommented;

  const UserCommentStatus({required this.hasCommented});

  @override
  List<Object> get props => [hasCommented];
}
