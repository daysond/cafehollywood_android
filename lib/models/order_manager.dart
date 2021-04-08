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
    print('adding receipt count ${pastOrders.length}');
    pastOrders.addAll(receipts);
    print("after adding count ${pastOrders.length}");
    receipts.forEach((element) {
      print(element.orderID);
    });
  }

  void addReceipt(Receipt receipt) {
    pastOrders.add(receipt);
    notifyListeners();
  }
}
