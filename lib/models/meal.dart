import 'package:decimal/decimal.dart';

class Meal {
  final String uid;
  final String name;
  final Decimal price;
  final String? details;
  final String? imageURL;
  final String mealDescription;
  final int? comboMealTag;

  List<String>? preferences;
  //combo type
  //is favourite
  //combo tag ?
  bool isSelected = false;
  int quantity = 1;

  Meal(this.uid, this.name, this.price, this.mealDescription,
      {this.imageURL, this.comboMealTag, this.preferences, this.details});
}
