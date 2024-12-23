import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/presentation/cubit/comments_cubit.dart';
import 'package:hyper_market/feature/details/presentation/view/product_reviewss_view.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/details_view_body.dart';

class CommentsTextWidget extends StatefulWidget {
  const CommentsTextWidget({
    super.key,
    required this.widget,
    required this.isSmallScreen,
  });

  final DetailsViewBody widget;
  final bool isSmallScreen;

  @override
  State<CommentsTextWidget> createState() => _CommentsTextWidgetState();
}

class _CommentsTextWidgetState extends State<CommentsTextWidget> {
  late String _productId;

  @override
  void initState() {
    super.initState();
    _productId = widget.widget.product.id!;
    _loadComments(); // جلب التعليقات الأولية
  }

  @override

void didUpdateWidget(CommentsTextWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  final newProductId = widget.widget.product.id!;
  if (_productId != newProductId) {
    _productId = newProductId;
    _loadComments(); 
  }
}


 void _loadComments() {
  if (!mounted) return;

  final commentCubit = context.read<CommentCubit>();
 
  commentCubit.getProductComments(_productId); 
}

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        Widget trailing;

        if (state is CommentLoading ) {
          trailing = const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: TColors.primary,
            ),
          );
        } else if (state is CommentsLoaded) {
          trailing = Text(
            '(${state.comments.length})',
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: widget.isSmallScreen ? 14 : 16,
              color: TColors.primary,
            ),
          );
        } else {
          return Text('0');// الحالة الافتراضية
        }

        return TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              ProductReviewsView.routeName,
              arguments: _productId,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.comment_outlined, size: 22),
              Text(
                'التعليقات',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: widget.isSmallScreen ? 16 : 18,
                  color: TColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              trailing, // عرض العدد أو المؤشر
            ],
          ),
        );
      },
    );
  }
}
