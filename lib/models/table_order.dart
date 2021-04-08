import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/meal_info.dart';

class TableOrder {
  String orderID;
  String customerID;
  String customerPhoneNumber;
  String customerName;
  String orderTimestamp;
  List<MealInfo> meals;
  OrderStatus status;
  String table;

  TableOrder(
      this.orderID,
      this.customerID,
      this.customerName,
      this.customerPhoneNumber,
      this.orderTimestamp,
      this.meals,
      this.table,
      this.status);
}
