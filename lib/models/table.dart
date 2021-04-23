import 'package:cafe_hollywood/models/enums/combo_type.dart';
import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:cafe_hollywood/models/table_order.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class DineInTable extends ChangeNotifier {
  static DineInTable? _instance;
  DineInTable._internal() {
    _instance = this;
  }
  factory DineInTable() => _instance ?? DineInTable._internal();

  String? tableNumber;
  String? timestamp = '';
  List<TableOrder> tableOrders = [];

  List<String> get orderIDs {
    return tableOrders.map((e) => e.orderID).toList();
  }

  List<TableOrder> get unconfirmedOrders {
    return tableOrders
        .where((order) => order.status == OrderStatus.unconfirmed)
        .toList()
          ..sort((o1, o2) => int.parse(o1.orderTimestamp)
              .compareTo(int.parse(o2.orderTimestamp)));
  }

  List<TableOrder> get confirmedOrders {
    return tableOrders
        .where((order) => order.status == OrderStatus.confirmed)
        .toList()
          ..sort((o1, o2) => int.parse(o1.orderTimestamp)
              .compareTo(int.parse(o2.orderTimestamp)));
  }

  List<TableOrder> get cancelledOrders {
    return tableOrders
        .where((order) => order.status == OrderStatus.cancelled)
        .toList()
          ..sort((o1, o2) => int.parse(o1.orderTimestamp)
              .compareTo(int.parse(o2.orderTimestamp)));
  }

  List<MealInfo> get unconfirmedMeals {
    return unconfirmedOrders.expand((element) => element.meals).toList();
    // shouldShowAllOrders ? unconfirmedOrders.sorted{ $0.orderTimestamp < $1.orderTimestamp }.flatMap { $0.meals }
  }

  List<MealInfo> get confirmedMeals {
    return confirmedOrders.expand((element) => element.meals).toList();
  }

  List<MealInfo> get cancelledMeals {
    return cancelledOrders.expand((element) => element.meals).toList();
  }

  Decimal get subTotal {
    if (confirmedMeals.length == 0) {
      return Decimal.parse('0');
    }
    var sub = confirmedMeals
        .map((e) => e.totalPrice)
        .toList()
        .reduce((a, b) => a + b);

    return sub - promotionAmount - discountAmount;
  }

  Decimal get discountAmount {
    var discountAmount = Decimal.parse('0');

    List<ComboType> drinkCombos = [];
    List<ComboType> wingCombos = [];

    List<int> drinkTags = [];
    List<int> wingTags = [];

    confirmedMeals.forEach((meal) {
      print(
          '${meal.name} combo tag ${meal.comboTag} combo Type ${meal.comboType}');
      for (int i = 1; i <= meal.quantity; i++) {
        if (meal.comboType != null) {
          switch (meal.comboType!) {
            case ComboType.drink:
              {
                drinkCombos.add(ComboType.drink);
              }
              break;
            case ComboType.wing:
              {
                wingCombos.add(ComboType.wing);
              }
              break;
          }
        }
        if (meal.comboTag != null) {
          meal.comboTag == 0
              ? drinkTags.add(meal.comboTag!)
              : wingTags.add(meal.comboTag!);
        }
      }
    });

    discountAmount += drinkCombos.length < drinkTags.length
        ? ComboType.drink.deductionAmount *
            Decimal.parse(drinkCombos.length.toString())
        : ComboType.drink.deductionAmount *
            Decimal.parse(drinkTags.length.toString());

    discountAmount += wingCombos.length < wingTags.length
        ? ComboType.wing.deductionAmount *
            Decimal.parse(wingCombos.length.toString())
        : ComboType.wing.deductionAmount *
            Decimal.parse(wingTags.length.toString());

    return discountAmount;
  }

  Decimal get promotionAmount {
    return Decimal.parse('0');
  }

  Decimal get taxes {
    return subTotal * Decimal.parse(0.13.toString());
  }

  Decimal get total {
    return subTotal + taxes;
  }

  void addOrder(TableOrder order) {
    print('did get order ${order.orderID}');
    tableOrders.add(order);
    notifyListeners();
  }

  Map<String, String> get representation {
    return {
      "tableNumber": tableNumber ?? "Error Table",
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }

  void reset() {
    // NotificationCenter.default.post(name: .didCloseTable, object: nil)
    //    @objc private func handleTableClosed()
    // isMenuOpened = false
    print('reset table');
    tableNumber = null;
    timestamp = null;
    tableOrders.clear();
    print(tableOrders.length);

    // Table.shared.shouldShowAllOrders = true
  }
}
