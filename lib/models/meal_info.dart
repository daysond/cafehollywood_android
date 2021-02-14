import 'package:cafe_hollywood/models/enums/combo_type.dart';
import 'package:decimal/decimal.dart';



class MealInfo {
  final String mealInfoID;
  final String name;
  final int quantity;
  final Decimal totalPrice;
  String addOnInfo;
  String instruction;
  ComboType comboType;
  int comboTag;

  MealInfo(this.mealInfoID, this.name, this.quantity, this.totalPrice,
      this.addOnInfo, this.instruction,
      {this.comboTag, this.comboType});
}
