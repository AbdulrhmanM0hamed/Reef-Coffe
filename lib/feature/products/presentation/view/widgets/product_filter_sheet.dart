import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';

class ProductFilterSheet extends StatefulWidget {
  final Function(double, double, bool, bool) onApplyFilter;

  const ProductFilterSheet({
    Key? key,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _isNatural = false;
  bool _hasDiscount = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'تصفية المنتجات',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'نطاق السعر',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
            ),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: TColors.primary,
            labels: RangeLabels(
              '${_priceRange.start.round()} جنيه',
              '${_priceRange.end.round()} جنيه',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              'منتجات بها خصم فقط',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
              ),
            ),
            value: _hasDiscount,
            activeColor: TColors.primary,
            onChanged: (value) {
              setState(() {
                _hasDiscount = value;
              });
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilter(
                  _priceRange.start,
                  _priceRange.end,
                  _isNatural,
                  _hasDiscount,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'تطبيق الفلتر',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
