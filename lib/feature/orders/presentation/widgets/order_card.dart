import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/feature/orders/domain/entities/order.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TColors.accent.withOpacity(.2),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'رقم الطلب: ${order.id.substring(0, 8)}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'التاريخ: ${DateFormat('dd/MM/yyyy - hh:mm a').format(order.createdAt)}',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'العنوان: ${order.deliveryAddress}',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'الإجمالي: ${order.totalAmount.toStringAsFixed(2)} جنيه',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: TColors.primary,
              ),
            ),
            if (order.items.isNotEmpty) ...[
              const Divider(),
              Text(
                'المنتجات:',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          )
                        : null,
                    title: Text(
                      item.productName,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                      ),
                    ),
                    subtitle: Text(
                      '${item.quantity} × ${item.price} جنيه',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'completed':
        return TColors.primary;
      case 'delivered':
        return Colors.teal;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }



  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'processing':
        return 'جارى المراجعة';
      case 'accepted':
        return 'مقبول';
      case 'completed':
        return 'جارى التوصيل';
      case 'delivered':
        return 'تم التسليم';
      case 'canceled':
        return 'ملغي';
      default:
        return status;
    }
  }
}
