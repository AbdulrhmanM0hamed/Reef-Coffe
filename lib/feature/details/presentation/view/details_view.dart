import 'package:flutter/material.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/details_view_body.dart';
import 'package:hyper_market/feature/products/domain/entities/product.dart';

class DetailsView extends StatelessWidget {
  final Product product;
    static const String routeName = "DetailsView";


  const DetailsView({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DetailsViewBody(product: product),
      ),
    );
  }
}