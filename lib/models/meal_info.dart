import 'package:cafe_hollywood/models/enums/combo_type.dart';
import 'package:decimal/decimal.dart';

class MealInfo {
  final String mealInfoID;
  final String name;
  final int quantity;
  final Decimal totalPrice;
  final String addOnInfo;
  final String instruction;
  final ComboType comboType;
  final int comboTag;

  MealInfo(this.mealInfoID, this.name, this.quantity, this.totalPrice,
      this.addOnInfo, this.instruction, this.comboType, this.comboTag);
}
