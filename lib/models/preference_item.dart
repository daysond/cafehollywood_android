import 'package:decimal/decimal.dart';

class PreferenceItem {
  final String uid;
  final String itemDescription;
  final String name;
  final Decimal price;
  final int quantity;
  int comboTag;
  bool isSelected = false;

  PreferenceItem(
      this.uid, this.name, this.itemDescription, this.price, this.quantity);
}
