import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/core/utils/common/custom_app_bar.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/domain/entities/comment.dart';
import 'package:hyper_market/feature/details/presentation/cubit/comments_cubit.dart';
import 'package:hyper_market/feature/details/presentation/cubit/rating_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductReviewsView extends StatefulWidget {
  final String productId;

  static const String routeName = 'productReviews';

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

    await _commentCubit.getProductComments(widget.productId);
    await _ratingCubit.loadProductRating(widget.productId);

    if (!_disposed && mounted) {
      final hasCommented = await _commentCubit.commentRepository
          .hasUserCommented(widget.productId);
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

  Widget buildRatingBar() {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final textScaleFactor = MediaQuery.of(context).textScaleFactor;

        if (state is RatingLoading) {
          return _buildRatingBarShimmer();
        }

        if (state is ProductRatingLoaded) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
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
                      style: TextStyle(
                        fontSize: 48 * textScaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Icon(
                      Icons.star,
                      color: Colors.amber[700],
                      size: 40 * textScaleFactor,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  '${state.count} تقييم',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 16 * textScaleFactor,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                buildRatingBars(state),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRatingBarShimmer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
            child: Row(
              children: [
                Container(
                  width: size.width * 0.15,
                  child: Text(
                    '${5 - index}',
                    style: TextStyle(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: size.height * 0.01,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.04),
                Container(
                  width: size.width * 0.1,
                  child: Text(
                    '0%',
                    style: TextStyle(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRatingBars(ProductRatingLoaded state) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Column(
      children: List.generate(5, (index) {
        final ratingLevel = 5 - index;
        final ratingCount =
            (state.ratingCounts[ratingLevel.toString()] as num?)?.toInt() ?? 0;
        final percentage =
            state.count > 0 ? (ratingCount / state.count) * 100 : 0.0;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.08,
                child: Row(
                  children: [
                    Text(
                      '$ratingLevel',
                      style: TextStyle(
                        fontSize: 16 * textScaleFactor,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(width: size.width * 0.005),
                    Icon(
                      Icons.star,
                      color: Colors.amber[700],
                      size: 14 * textScaleFactor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: percentage / 100),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[300],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.amber[700]!),
                      minHeight: size.height * 0.01,
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              SizedBox(
                width: size.width * 0.12,
                child: Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12 * textScaleFactor,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.1,
                child: Text(
                  '($ratingCount)',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12 * textScaleFactor,
                  ),
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
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _commentCubit),
        BlocProvider.value(value: _ratingCubit),
      ],
      child: Scaffold(
        appBar: customAppBar(context, 'المراجعات'),
        body: RefreshIndicator(
          onRefresh: _loadInitialData,
          child: Column(
            children: [
              buildRatingBar(),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: BlocConsumer<CommentCubit, CommentState>(
                  bloc: _commentCubit,
                  listener: (context, state) {
                    if (state is CommentError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is CommentLoading) {
                      return _buildCommentsShimmer();
                    }

                    if (state is CommentsLoaded) {
                      final comments = state.comments;
                      if (comments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'لا يوجد تعليقات حتى الآن',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  fontSize: 16 * textScaleFactor,
                                ),
                              ),
                              if (!_hasExistingComment) ...[
                                SizedBox(height: size.height * 0.02),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _showAddCommentDialog(context),
                                  icon: const Icon(Icons.add_comment),
                                  label: Text(
                                    'أضف تعليق',
                                    style: getBoldStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: 16 * textScaleFactor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.05,
                                      vertical: size.height * 0.015,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.all(size.width * 0.04),
                              itemCount: comments.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: size.height * 0.01),
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                final isCurrentUserComment =
                                    comment.userId == _currentUserId;

                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                    vertical: size.height * 0.005,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isCurrentUserComment
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2)
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(size.width * 0.04),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // User Avatar
                                              CircleAvatar(
                                                radius: size.width * 0.05,
                                                backgroundColor:
                                                    _getAvatarColor(comment.userName),
                                                child: Text(
                                                  comment.userName.characters.first
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16 * textScaleFactor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: size.width * 0.03),
                                              // Comment Content
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            comment.userName,
                                                            style: getBoldStyle(
                                                              fontFamily:
                                                                  FontConstant.cairo,
                                                              fontSize: 16 *
                                                                  textScaleFactor,
                                                              color: Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium
                                                                  ?.color,
                                                            ),
                                                          ),
                                                        ),
                                                        if (isCurrentUserComment)
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context)
                                                                  .primaryColor
                                                                  .withOpacity(0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(8),
                                                            ),
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.edit,
                                                                size: 20 *
                                                                    textScaleFactor,
                                                                color:
                                                                    Theme.of(context)
                                                                        .primaryColor,
                                                              ),
                                                              onPressed: () =>
                                                                  _showEditCommentDialog(
                                                                      context,
                                                                      comment),
                                                              tooltip:
                                                                  'تعديل التعليق',
                                                              constraints:
                                                                  BoxConstraints(
                                                                minWidth:
                                                                    size.width * 0.08,
                                                                minHeight:
                                                                    size.width * 0.08,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: size.height * 0.01),
                                                    Text(
                                                      comment.comment,
                                                      style: TextStyle(
                                                        fontSize:
                                                            14 * textScaleFactor,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.color,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: size.height * 0.01),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.access_time,
                                                          size: 14 * textScaleFactor,
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.color,
                                                        ),
                                                        SizedBox(
                                                            width: size.width * 0.01),
                                                        Text(
                                                          timeago.format(
                                                              comment.createdAt,
                                                              locale: 'ar'),
                                                          style: getRegularStyle(
                                                            fontFamily:
                                                                FontConstant.cairo,
                                                            fontSize:
                                                                12 * textScaleFactor,
                                                            color: Theme.of(context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_currentUserId != null && !_hasExistingComment)
                            Padding(
                              padding: EdgeInsets.all(size.width * 0.04),
                              child: ElevatedButton(
                                onPressed: () => _showAddCommentDialog(context),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(size.width * 0.9, size.height * 0.06),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'إضافة تعليق',
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: 16 * textScaleFactor,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsShimmer() {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: EdgeInsets.all(size.width * 0.04),
      itemCount: 5,
      separatorBuilder: (context, index) =>
          SizedBox(height: size.height * 0.01),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
        child: Container(
          height: size.height * 0.15,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  bool _isValidComment(String comment) {
    if (comment.length > 35) {
      return false;
    }

    RegExp gibberishPattern = RegExp(r'[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]{5,}');
    if (gibberishPattern.hasMatch(comment)) {
      return false;
    }

    return true;
  }

  void _showAddCommentDialog(BuildContext context) {
    final commentController = TextEditingController();
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaler;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إضافة تعليق',
          style: getBoldStyle(fontFamily: FontConstant.cairo),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'اكتب تعليقك هنا',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: getBoldStyle(fontFamily: FontConstant.cairo),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final comment = commentController.text.trim();
              if (comment.isNotEmpty) {
                if (!_isValidComment(comment)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('التعليق غير صالح. يجب أن يكون أقل من 25 حرف ولا يحتوي على نص عشوائي'),
                    ),
                  );
                  return;
                }
                
                if (!_hasExistingComment) {
                  await _commentCubit.addComment(
                    widget.productId,
                    comment,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              }
            },
            child: Text(
              'إضافة',
              style: getBoldStyle(fontFamily: FontConstant.cairo),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditCommentDialog(BuildContext context, Comment comment) {
    final commentController = TextEditingController(text: comment.comment);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تعديل التعليق',
          style: getBoldStyle(fontFamily: FontConstant.cairo),
        ),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'اكتب تعليقك هنا',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: getBoldStyle(fontFamily: FontConstant.cairo),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newComment = commentController.text.trim();
              if (newComment.isNotEmpty) {
                if (!_isValidComment(newComment)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('التعليق غير صالح. يجب أن يكون أقل من 25 حرف ولا يحتوي على نص عشوائي'),
                    ),
                  );
                  return;
                }

                await _commentCubit.updateComment(
                  widget.productId,
                  // comment.id,
                  newComment,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text('تحديث', style: getBoldStyle(fontFamily: FontConstant.cairo)),
          ),
        ],
      ),
    );
  }

  // Helper method to generate consistent avatar colors based on username
  Color _getAvatarColor(String userName) {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.red,
    ];

    int hash = userName.hashCode;
    return colors[hash.abs() % colors.length];
  }
}
