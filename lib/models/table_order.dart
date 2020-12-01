enum OrderStatus {
  cancelled,
  unconfirmed,
  confirmed,
  ready,
  completed,
//    case sent = 5
  scheduled,
  scheduledConfirmed,
}

class TableOrder {
  String orderID;
  OrderStatus status;
  TableOrder(this.orderID, this.status);
}
