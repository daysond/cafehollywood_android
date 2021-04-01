import 'package:cafe_hollywood/models/enums/combo_type.dart';
import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/models/table_order.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:cafe_hollywood/models/enums/order_status.dart';

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
    var discountAmount = Decimal.parse('0');

    List<ComboType> drinkCombos = [];
    List<ComboType> wingCombos = [];

    List<int> drinkTags = [];
    List<int> wingTags = [];

    meals.forEach((meal) {
      print(
          '${meal.name} combo tag ${meal.comboTag} combo Type ${meal.comboType}');
      for (int i = 1; i <= meal.quantity; i++) {
        if (meal.comboType != null) {
          switch (meal.comboType) {
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
              ? drinkTags.add(meal.comboTag)
              : wingTags.add(meal.comboTag);
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

  Decimal get cartSubtotal {
    if (meals.length == 0) {
      return Decimal.parse('0');
    }
    var sub = meals.map((e) => e.totalPrice).toList().reduce((a, b) => a + b);

    return sub - promotionAmount - discountAmount;
  }

  Decimal get cartTaxes {
    return cartSubtotal * Decimal.parse(0.13.toString());
  }

  Decimal get cartTotal {
    return cartSubtotal + cartTaxes;
  }

  String get orderTimestamp {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String orderNote;

  String pickupTime;

  String pickupDate;

  bool needsUtensil = true;

  bool get isEmpty {
    return meals.isEmpty;
  }

  void addMealToCart(Meal meal) {
    meals.add(meal);
    notifyListeners();
    print('meal added!');
  }

  void removeMeal(Meal meal) {
    meals.remove(meal);
    notifyListeners();
    print('removdddd');
  }

  void didUpdateCart() {
    notifyListeners();
  }

  void resetCart() {
    meals = [];
    pickupDate = null;
    pickupTime = null;
    needsUtensil = true;
    giftOptionContent = {};
    selectedGiftOption = null;
    orderNote = null;

    notifyListeners();
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
    List mealsInfo = meals.map((e) => e.representation).toList();

    meals.forEach((meal) {});
    Map<String, dynamic> rep = {
      "customerID": APPSetting().customerUID,
      "customerName": APPSetting().customerName,
      "customerPhoneNumber": APPSetting().customerPhoneNumber,
      "subtotal": cartSubtotal.toDouble(),
      "total": cartTotal.toDouble(),
      "taxes": cartTaxes.toDouble(),
      "discount": discountAmount.toDouble(),
      "promotion": promotionAmount.toDouble(),
      "orderNote": orderNote,
      "orderTimestamp": orderTimestamp,
      "status": pickupTime == null
          ? OrderStatus.unconfirmed.rawValue
          : OrderStatus.scheduled.rawValue,
      "mealsInfo": mealsInfo,
      "needsUtensil": needsUtensil,
    };

    return rep;

    // if self.pickupTime != nil {
    //     rep["pickupTime"] = pickupTime!
    // }

    // if self.pickupDate != nil {
    //     rep["pickupDate"] = pickupDate!
    // }

    // if self.giftOptionContent != nil {
    //     rep["giftOptionContent"] = giftOptionContent!
    // }
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
