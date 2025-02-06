import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'الشروط والأحكام',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: TColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'مقدمة:',
                'مرحباً بك في تطبيق ريف القهوة للطلبات الصحية والمكملات الغذائية. باستخدامك للتطبيق، فإنك توافق على الشروط والأحكام التالية.',
              ),
              const SizedBox(height: 10),
              _buildSection(
                'الطلبات والتوصيل:',
                '• نلتزم بتوصيل الطلبات في الوقت المحدد\n'
                    '• منطقة التوصيل محددة حسب تغطية خدمتنا\n'
                    '• رسوم التوصيل تختلف حسب المنطقة',
              ),
              const SizedBox(height: 10),
              _buildSection(
                'المنتجات والجودة:',
                '• نضمن جودة وأصالة جميع المكملات الغذائية\n'
                    '• جميع منتجاتنا مرخصة من الجهات المختصة\n'
                    '• نلتزم بشروط التخزين والنقل الآمن\n'
                    '• يمكن إرجاع المنتج في حال وجود عيب مصنعي',
              ),
              const SizedBox(height: 10),
              _buildSection(
                'الدفع والأسعار:',
                '• نقبل الدفع عند الاستلام والدفع الإلكتروني\n'
                    '• الأسعار تشمل ضريبة القيمة المضافة\n'
                    '• قد تتغير الأسعار دون إشعار مسبق',
              ),
              const SizedBox(height: 10),
              _buildSection(
                'الخصوصية والأمان:',
                '• نحمي بياناتك الشخصية بأقصى درجات الأمان\n'
                    '• لن نشارك بياناتك مع أي طرف ثالث\n'
                    '• نستخدم بياناتك فقط لتحسين خدماتنا',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'موافق',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: TColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: TColors.primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
           
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTermsDialog(context),
      child: Text.rich(
        TextSpan(
          text: "بالتسجيل، أنت توافق على ",
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
          ),
          children: [
            TextSpan(
              text: "الشروط والأحكام \nالخاصة بنا",
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: TColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
