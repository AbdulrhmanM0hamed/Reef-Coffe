import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/domain/entities/comment.dart';
import 'package:hyper_market/feature/details/presentation/cubit/comment_cubit.dart';
import 'package:hyper_market/feature/details/presentation/cubit/rating_cubit.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductReviewsView extends StatefulWidget {
  final String productId;

  const ProductReviewsView({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductReviewsView> createState() => _ProductReviewsViewState();
}

class _ProductReviewsViewState extends State<ProductReviewsView> {
  late final CommentCubit _commentCubit;
  late final RatingCubit _ratingCubit;
  bool _disposed = false;
  bool _hasExistingComment = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _commentCubit = CommentCubit(commentRepository: getIt());
    _ratingCubit = getIt<RatingCubit>();
    _loadInitialData();
    _currentUserId = getIt<SupabaseClient>().auth.currentUser?.id;
  }

  Future<void> _loadInitialData() async {
    if (_disposed) return;

    // تحميل التعليقات والتقييمات
    await _commentCubit.getProductComments(widget.productId);
    await _ratingCubit.loadProductRating(widget.productId);

    // التحقق من وجود تعليق للمستخدم
    if (!_disposed && mounted) {
      final hasCommented = await _commentCubit.commentRepository.hasUserCommented(widget.productId);
      setState(() {
        _hasExistingComment = hasCommented.fold(
          (failure) => false,
          (hasCommented) => hasCommented,
        );
      });
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _commentCubit.close();
    _ratingCubit.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProductReviewsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _loadInitialData();
    }
  }

  Widget _buildRatingBar() {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        if (state is ProductRatingLoaded) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${state.rating.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.star,
                      color: Colors.amber[700],
                      size: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.count} تقييم',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRatingBars(state),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRatingBars(ProductRatingLoaded state) {
    return Column(
      children: List.generate(5, (index) {
        final ratingLevel = 5 - index;
        // الحصول على عدد التقييمات لهذا المستوى
        final ratingCount = (state.ratingCounts[ratingLevel.toString()] as num?)?.toInt() ?? 0;
        
        // حساب النسبة المئوية
        final percentage = state.count > 0 
            ? (ratingCount / state.count) * 100 
            : 0.0;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Row(
                  children: [
                    Text(
                      '$ratingLevel',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.star, color: Colors.amber[700], size: 14),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[700]!),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 50,
                child: Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '($ratingCount)',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _commentCubit),
        BlocProvider.value(value: _ratingCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المراجعات'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _loadInitialData,
          child: Column(
            children: [
              _buildRatingBar(),
              const SizedBox(height: 16),
              Expanded(
                child: BlocConsumer<CommentCubit, CommentState>(
                  bloc: _commentCubit,
                  listener: (context, state) {
                    if (state is CommentError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is CommentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CommentsLoaded) {
                      final comments = state.comments;
                      if (comments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('لا يوجد تعليقات حتى الآن'),
                              if (!_hasExistingComment)
                                ElevatedButton(
                                  onPressed: () => _showAddCommentDialog(context),
                                  child: const Text('أضف تعليق'),
                                ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: comments.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final isCurrentUserComment = comment.userId == _currentUserId;

                          return Card(
                            child: ListTile(
                              title: Text(
                                comment.userName,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(comment.comment),
                                  const SizedBox(height: 4),
                                  Text(
                                    timeago.format(comment.createdAt, locale: 'ar'),
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: isCurrentUserComment
                                  ? IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _showEditCommentDialog(context, comment),
                                    )
                                  : null,
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: !_hasExistingComment
            ? FloatingActionButton.extended(
                onPressed: () => _showAddCommentDialog(context),
                icon: const Icon(Icons.add_comment),
                label: const Text('إضافة تعليق'),
              )
            : null,
      ),
    );
  }

  void _showAddCommentDialog(BuildContext context) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة تعليق'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'اكتب تعليقك هنا',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (commentController.text.isNotEmpty) {
                Navigator.pop(context);
                await _commentCubit.addComment(
                  widget.productId,
                  commentController.text,
                );
                if (mounted) {
                  setState(() {
                    _hasExistingComment = true;
                  });
                }
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditCommentDialog(BuildContext context, Comment comment) {
    final commentController = TextEditingController(text: comment.comment);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعديل التعليق'),
        content: TextField(
          autofocus: true,
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'اكتب تعليقك هنا',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (commentController.text.isNotEmpty) {
                Navigator.pop(dialogContext);
                await _commentCubit.updateComment(
                  widget.productId,
                  commentController.text,
                );
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث التعليق بنجاح'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }
}
