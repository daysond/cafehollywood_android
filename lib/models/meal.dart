import 'package:cafe_hollywood/models/enums/combo_type.dart';
import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:decimal/decimal.dart';

class Meal {
  final String uid;
  final String name;
  final Decimal price;
  final String details;
  String? imageURL;
  final String mealDescription;
  int? comboMealTag;
  bool? isBogo = false;
  String? instruction;
  ComboType? comboType;
  List<Preference>? preferences;
  bool isSelected = false;
  int quantity = 1;

  Meal(this.uid, this.name, this.price, this.mealDescription, this.details,
      {this.imageURL, this.comboMealTag, this.preferences, this.isBogo});

  Future<bool> isFavourite() async {
    return APPSetting()
        .favouriteMealList()
        .then((favList) => favList.contains(uid));
  }

  Meal copy(Meal meal) {
    Meal newMeal = Meal(
        meal.uid, meal.name, meal.price, meal.mealDescription, meal.details,
        imageURL: meal.imageURL,
        comboMealTag: meal.comboMealTag,
        isBogo: meal.isBogo);
    newMeal.quantity = meal.quantity;
    newMeal.instruction = meal.instruction;
    newMeal.comboType = meal.comboType;
    if (meal.preferences != null) {
      newMeal.preferences = meal.preferences!.map((e) => e.copy(e)).toList();
    }
    return newMeal;
  }

  int? get comboTag {
    int? tag;
    if (comboMealTag != null) {
      tag = comboMealTag!;
    } else {
      if (preferences == null) {
        return null;
      } else {
        preferences!.forEach((preference) {
          if (preference.isRequired) {
            for (PreferenceItem item in preference.preferenceItems) {
              if (item.isSelected && item.comboTag != null) {
                tag = item.comboTag!;
              }
            }
          }
        });
      }
      // return null;
    }
    return tag;
  }

  Decimal get addonPrice {
    if (preferences == null) {
      return Decimal.parse('0');
    }
    Decimal total = Decimal.parse('0');
    preferences!.forEach((preference) {
      preference.preferenceItems.forEach((item) {
        if (item.isSelected && item.price != null) {
          total = total + item.price! * Decimal.parse(item.quantity.toString());
        }
      });
    });
    return total;
  }

  Decimal get totalPrice {
    return (addonPrice + price) * Decimal.parse(quantity.toString());
  }

  String get addOnInfo {
    String addOnDetails = '';
    if (preferences == null) {
      return addOnDetails;
    } else {
      preferences!.forEach((preference) {
        preference.preferenceItems.forEach((item) {
          if (item.isSelected) {
            addOnDetails = item.quantity == 1
                ? "${addOnDetails}${item.name}"
                : "${addOnDetails}${item.quantity} ${item.name}";

            addOnDetails = item.price == null
                ? "${addOnDetails}\n"
                : "${addOnDetails} (\$${item.price! * Decimal.parse(item.quantity.toString())})\n";
          }
        });
      });
      return addOnDetails;
    }
  }

  String get addOnDescription {
    String addOnDetails = "";

    if (preferences == null) {
      return addOnDetails;
    } else {
      preferences!.forEach((preference) {
        preference.preferenceItems.forEach((item) {
          if (item.isSelected) {
            addOnDetails = item.quantity == 1
                ? "${addOnDetails}${item.itemDescription}"
                : "${addOnDetails}${item.quantity} ${item.itemDescription}";

            addOnDetails = item.price == null
                ? "${addOnDetails}\n"
                : "${addOnDetails} (\$${item.price! * Decimal.parse(item.quantity.toString())})\n";
          }
        });
      });

      return addOnDetails.trimRight();
    }
  }

  bool get isModificationRequired {
    if (preferences == null) return false;
    bool isRequired = false;
    preferences!.forEach((preference) {
      if (preference.isRequired) {
        for (var item in preference.preferenceItems) {
          if (item.isSelected) {
            isRequired = false;
            break;
          } else {
            isRequired = true;
          }
        }
      }
    });
    return isRequired;
  }

  Map<String, dynamic> get preferencesInEncodedJSON {
    Map<String, dynamic> data = {};

    Map<String, dynamic> preferencesInfo = {};

    if (instruction != null) data["instruction"] = instruction;

    if (preferences != null) {
      preferences!.forEach((preference) {
        List<Map<String, int>> selectedItems = [];
        preference.preferenceItems.forEach((item) {
          if (item.isSelected) selectedItems.add({item.uid: item.quantity});
        });

        if (selectedItems.length > 0) {
          preferencesInfo[preference.uid] = selectedItems;
        }
      });
    }

    data["preferences"] = preferencesInfo;

    return data;
  }

  Map<String, dynamic> get representation {
    return {
      "uid": uid,
      "name": name,
      "instruction": instruction ?? "",
      "quantity": quantity,
      "totalPrice": totalPrice.toDouble(),
      "addOnInfo": addOnInfo,
      "description": mealDescription,
      "addOnDescription": addOnDescription,
      if (comboTag != null) 'comboTag': comboTag,
      if (comboType != null) 'comboType': comboType!.rawValue,
    };
  }
}

/*
      var representation: [String : Any] {
        
        var rep: [String: Any] = [
            "uid": uid,
            "name": name,
            "instruction" : instruction ?? "",
            "quantity" : quantity,
            "totalPrice" : totalPrice.amount,
            "addOnInfo" : addOnInfo,
            "description": mealDescription,
            "addOnDescription": addOnDescription,
            
        ]
        
        if comboTag != nil {
            rep["comboTag"] = comboTag
        }
        
        if comboType != nil {
            rep["comboType"] = comboType?.rawValue
        }
        
        return rep
    }
    
    
    var addOnDescription: String {

    }


*/
