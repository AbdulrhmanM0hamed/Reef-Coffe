import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_market/core/utils/common/elvated_button.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class DetailsViewBody extends StatelessWidget {
  const DetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          Image.asset(
            'assets/images/Apple.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'تفاح احمر',
                style: getBoldStyle(
                    fontFamily: FontConstant.cairo, fontSize: FontSize.size20),
              ),
              const Spacer(),
              Icon(
                Icons.favorite_border,
                color: TColors.darkGrey,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '100 جنيه/  كيلو',
                style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: TColors.secondary),
              ),
              Row(
                children: [
                  Container(
                    width: sizeWidth * 0.08,
                    height: sizeWidth * 0.08,
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? TColors.black
                          : TColors.white,
                      size: sizeWidth * 0.05,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '4',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size18,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.remove,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.grey
                        : TColors.black,
                    size: sizeWidth * 0.055,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                color: TColors.pound,
                size: sizeWidth * 0.06,
              ),
              SizedBox(
                height: 10,
              ),
              Text("4.5",
                  style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16)),
              SizedBox(
                width: 10,
              ),
              Text("(+30)",
                  style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: TColors.darkGrey)),
              SizedBox(
                width: 10,
              ),
              Text(
                "المراجعة",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: sizeWidth * 0.041,
                  color: TColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'ينتمى الى فئة الفواكه الرائعة والتى توفر فيتامينات وعناصر  غذائية هامة لجسم الانسان وايضا طعمه لذيذ ومناسب لكل الاعمار ودائما الافبال عالى عليه ',
            style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: TColors.darkGrey),
          ),
          const SizedBox(
            height: 10,
          ),
          InfoSection(
            calendarNumber: "1",
          ),
          const SizedBox(
            height: 40,
          ),
          CustomElevatedButton(onPressed: () {}, buttonText: "اضف الى السلة")
        ],
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String calendarNumber;

  InfoSection({required this.calendarNumber});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // العناصر (نصوص وأيقونات) التي نريد عرضها
    final List<Map<String, dynamic>> items = [
      {
        "icon": "assets/images/calener.svg",
        "mainText": "عام",
        "subText": "الصلاحية",
        "badge": calendarNumber, // الرقم الديناميكي للأيقونة
      },
      {
        "icon": "assets/images/lotus.svg", // المسار إلى أيقونة SVG
        "mainText": "100%",
        "subText": "أورجانيك",
      },
      {
        "icon": "assets/images/calory.svg",
        "mainText": "80 كالوري",
        "subText": "100 جرام",
      },
      {
        "icon": "assets/images/favourites.svg",
        "mainText": "4.8",
        "subText": "Reviews",
        "extraText": "(256)",
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2, // نسبة العرض إلى الارتفاع
        ),
        itemBuilder: (context, index) {
          final item = items[index];

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.darkerGrey
                  : TColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // النصوص
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item["mainText"],
                        style: TextStyle(
                          fontSize: size.width * 0.044,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (item["extraText"] != null) // النص الإضافي مثل (256)
                        Text(
                          item["extraText"],
                          style: TextStyle(
                            fontSize: size.width * 0.027,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        item["subText"],
                        style: TextStyle(
                          fontSize: size.width * 0.033,
                          color: TColors.darkGrey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  // الأيقونة
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        item["icon"],
                        width: size.width * 0.07,
                        height: size.height * 0.065,
                      ),
                      if (item["badge"] != null) // الرقم الديناميكي
                        Positioned(
                          top: size.height * 0.020,
                          right: size.width * 0.055,
                          child: Text(
                            item["badge"],
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                              color: TColors.darkerGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
