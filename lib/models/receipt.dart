import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:decimal/decimal.dart';

class Receipt {
  final String orderID;
  final String customerID;
  final String orderTimestamp;
  final String orderNote;
  final Decimal discount;
  final Decimal promotion;
  final Decimal subtotal;
  final Decimal taxes;
  final Decimal total;
  final List<MealInfo> mealsInfo;
  final String customerName;
  OrderStatus status;
  String pickupTime;
  String pickupDate;
  Map<String, String> giftOptionContent;

  Receipt(
      this.orderID,
      this.customerID,
      this.orderTimestamp,
      this.orderNote,
      this.discount,
      this.promotion,
      this.subtotal,
      this.taxes,
      this.total,
      this.mealsInfo,
      this.status,
      this.customerName,
      {this.pickupDate,
      this.pickupTime,
      this.giftOptionContent});
}
