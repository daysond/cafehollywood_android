import 'package:cafe_hollywood/models/meal.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier {
  static Cart _instance;

  Cart._internal() {
    _instance = this;
  }
  factory Cart() => _instance ?? Cart._internal();

  List<Meal> meals = [];
  Map<String, String> giftOptionContent = {};
  Meal selectedGiftOption;
  Decimal get discountAmount {
    return Decimal.parse('0');
  }

  Decimal get cartSubtotal {
    return Decimal.parse('0');
  }

  Decimal get cartTaxes {
    return Decimal.parse('0');
  }

  Decimal get cartTotal {
    return meals.length == 0
        ? Decimal.parse('0')
        : meals.map((e) => e.price).toList().reduce((a, b) => a + b);
  }

  String get orderTimestamp {
    return 'Date.timestamp';
  }

  String orderNote = '';

  String pickupTime = '';

  String pickupDate = '';

  bool needUtensil = true;

  bool get isEmpty {
    return meals.isEmpty;
  }

  Function didUpdateCart;

  void addMealToCart(Meal meal) {
    meals.add(meal);
    notifyListeners();
  }

  void resetCart() {
    //   Cart.shared.meals.removeAll()
    // Cart.shared.orderNote = ""
    // Cart.shared.pickupTime = nil
    // Cart.shared.selectedGiftOption = nil
    // Cart.shared.giftOptionContent = nil
    // Cart.shared.promotion = nil
    // Cart.shared.needsUtensil = true
  }

  void removeGiftOption() {
    //     guard let option = Cart.shared.selectedGiftOption else {
    //     return
    // }
    // Cart.shared.selectedGiftOption = nil
    // giftOptionContent = nil
    // Cart.shared.meals.removeAll { $0.uid == option.uid }
  }

  Map get representation {
    Map rep = {};
    //     var rep: [String: Any] = [

    //     "customerID": APPSetting.customerUID,
    //     "customerName": APPSetting.customerName,
    //     "customerPhoneNumber": APPSetting.customerPhoneNumber,
    //     "subtotal": cartSubtotal.amount,
    //     "total": cartTotal.amount,
    //     "taxes": cartTaxes.amount,
    //     "discount": discountAmount?.amount ?? 0,
    //     "promotion": promotion?.amount ?? 0,
    //     "orderNote": orderNote,
    //     "orderTimestamp": orderTimestamp,
    //     "status": pickupTime == nil ? OrderStatus.unconfirmed.rawValue : OrderStatus.scheduled.rawValue,
    //     "mealsInfo": mealsInfo,
    //     "needsUtensil": needsUtensil,

    // ]

    // if self.pickupTime != nil {
    //     rep["pickupTime"] = pickupTime!
    // }

    // if self.pickupDate != nil {
    //     rep["pickupDate"] = pickupDate!
    // }

    // if self.giftOptionContent != nil {
    //     rep["giftOptionContent"] = giftOptionContent!
    // }
    return rep;
  }
}

/*    var dineInRepresentation: [String : Any] {
        
        
        var mealsInfo: [[String: Any]] = []
        
        meals.forEach { (meal) in
            mealsInfo.append(meal.representation)
        }
        
        let rep: [String: Any] = [
            "customerID": APPSetting.customerUID,
            "customerName": APPSetting.customerName,
            "customerPhoneNumber": APPSetting.customerPhoneNumber,
            "orderTimestamp": orderTimestamp,
            "status": OrderStatus.unconfirmed.rawValue,
            "mealsInfo": mealsInfo,
            "table": Table.shared.tableNumber ?? "Error Table"
        ]
        

            

        return rep
    } */
