import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/custom_nav_pop.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/nutritions_grid_view.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/price_with_additons.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/review.dart';
import 'package:hyper_market/feature/details/presentation/view/widgets/title_with_favorite.dart';

class DetailsViewBody extends StatelessWidget {
  const DetailsViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNavPop(),
            Container(
              width: double.infinity,
              height: sizeHeight * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/images/Apple.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: sizeHeight * 0.01),
            TitleWithFavorite(sizeWidth: sizeWidth),
            SizedBox(height: sizeHeight * 0.01),
            PriceWithButton_add_min(sizeWidth: sizeWidth),
            SizedBox(height: sizeHeight * 0.015),
            ReviewsWidget(sizeWidth: sizeWidth),
            SizedBox(height: sizeHeight * 0.015),
            Text(
              'ينتمى الى فئة الفواكه الرائعة والتى توفر فيتامينات وعناصر غذائية هامة لجسم الإنسان وايضا طعمه لذيذ ومناسب لكل الأعمار ودائما الإقبال على عليه',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: sizeWidth * 0.035,
                color: TColors.darkGrey,
              ),
            ),
            SizedBox(height: sizeHeight * 0.025),
            InfoSection(),
            SizedBox(height: sizeHeight * 0.018),
            CustomElevatedButton(
              onPressed: () {},
              buttonText: "اضف الى السلة",
            ),
          ],
        ),
      ),
    );
  }
}
