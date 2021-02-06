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

  List<Preference> preferences;
  //combo type
  //is favourite
  //combo tag ?
  bool isSelected = false;
  int quantity = 1;

  Meal(this.uid, this.name, this.price, this.mealDescription,
      {this.imageURL,
      this.comboMealTag,
      this.preferences,
      this.details,
      this.isBogo});
}
