import 'package:cafe_hollywood/models/preference.dart';
import 'package:decimal/decimal.dart';

class Meal {
  final String uid;
  final String name;
  final Decimal price;
  final String details;
  String imageURL;
  final String mealDescription;
  int comboMealTag;
  bool isBogo = false;
  String instruction;

  List<Preference> preferences;
  //combo type
  //is favourite
  //combo tag ?
  bool isSelected = false;
  int quantity = 1;

  Meal(this.uid, this.name, this.price, this.mealDescription, this.details,
      {this.imageURL, this.comboMealTag, this.preferences, this.isBogo});

  Meal copy(Meal meal) {
    Meal newMeal = Meal(
        meal.uid, meal.name, meal.price, meal.mealDescription, meal.details,
        imageURL: meal.imageURL,
        comboMealTag: meal.comboMealTag,
        isBogo: meal.isBogo,
        preferences: meal.preferences.map((e) => e.copy(e)).toList());
    newMeal.quantity = meal.quantity;
    return newMeal;
  }

  Decimal get addonPrice {
    if (preferences == null) {
      return Decimal.parse('0');
    }
    Decimal total = Decimal.parse('0');
    preferences.forEach((preference) {
      preference.preferenceItems.forEach((item) {
        if (item.isSelected && item.price != null) {
          total = total + item.price * Decimal.parse(item.quantity.toString());
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
      preferences.forEach((preference) {
        preference.preferenceItems.forEach((item) {
          if (item.isSelected) {
            addOnDetails = item.quantity == 1
                ? "${addOnDetails}${item.name}"
                : "${addOnDetails}${item.quantity} ${item.name}";

            addOnDetails = item.price == null
                ? "${addOnDetails}\n"
                : "${addOnDetails} (\$${item.price * Decimal.parse(item.quantity.toString())}\n";
          }
        });
      });
    }
  }

  String get addOnDescription {
    String addOnDetails = "";

    if (preferences == null) {
      return addOnDetails;
    } else {
      preferences.forEach((preference) {
        preference.preferenceItems.forEach((item) {
          if (item.isSelected) {
            addOnDetails = item.quantity == 1
                ? "${addOnDetails}${item.itemDescription}"
                : "${addOnDetails}${item.quantity} ${item.itemDescription}";

            addOnDetails = item.price == null
                ? "${addOnDetails}\n"
                : "${addOnDetails} (\$${item.price * Decimal.parse(item.quantity.toString())})\n";
          }
        });
      });

      return addOnDetails.trimRight();
    }
  }
}

/*

    
    
    var addOnDescription: String {

    }


*/
