import 'package:cafe_hollywood/models/receipt.dart';
import 'package:flutter/material.dart';

class OrderManager extends ChangeNotifier {
  static OrderManager? _instance;

  OrderManager._internal() {
    _instance = this;
  }

  factory OrderManager() => _instance ?? OrderManager._internal();

  List<Receipt> pastOrders = [];

  void addRecepits(List<Receipt> receipts) {
    pastOrders.addAll(receipts);
    pastOrders.sort((a, b) => b.orderTimestamp.compareTo(a.orderTimestamp));
  }

  void addReceipt(Receipt receipt) {
    pastOrders.add(receipt);
    pastOrders.sort((a, b) => b.orderTimestamp.compareTo(a.orderTimestamp));

    notifyListeners();
  }
}
