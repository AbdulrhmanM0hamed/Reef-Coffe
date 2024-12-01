import 'package:flutter/material.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/details_view_body.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  static const String routeName = "DetailsView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(child: DetailsViewBody()),
    );
  }
}