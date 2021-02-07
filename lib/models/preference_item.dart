import 'package:decimal/decimal.dart';

class PreferenceItem {
  final String uid;
  final String itemDescription;
  final String name;
  Decimal price;
  int quantity = 1;
  int comboTag;
  bool isSelected = false;

  PreferenceItem(this.uid, this.name, this.itemDescription, {this.price});
}
