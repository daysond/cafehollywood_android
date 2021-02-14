
import 'package:cafe_hollywood/models/enums/order_status.dart';

class TableOrder {
  String orderID;
  OrderStatus status;
  TableOrder(this.orderID, this.status);
}
