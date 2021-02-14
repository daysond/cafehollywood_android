import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/table_order.dart';

class Table {
  static Table _instance;
  Table._internal() {
    _instance = this;
  }
  factory Table() => _instance ?? Table._internal();

  String tableNumber;
  List<TableOrder> tableOrders = [];
  List<String> get orderIDs {
    return tableOrders.map((e) => e.orderID).toList();
  }

  List<TableOrder> get unconfirmedOrders {
    return tableOrders
        .where((order) => order.status == OrderStatus.unconfirmed)
        .toList();
  }

  List<TableOrder> get confirmedOrders {
    return tableOrders
        .where((order) => order.status == OrderStatus.confirmed)
        .toList();
  }

  List<TableOrder> get cancelledOrders {
    return tableOrders
        .where((order) => order.status == OrderStatus.cancelled)
        .toList();
  }
}
