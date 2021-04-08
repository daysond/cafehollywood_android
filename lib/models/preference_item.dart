import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class PreferenceItem {
  final String uid;
  final String itemDescription;
  final String name;
  Decimal? price;
  int quantity = 1;
  int? comboTag;
  bool isSelected = false;

  PreferenceItem(this.uid, this.name, this.itemDescription, {this.price});

  // void setSelected(bool isSelected) {
  //   this.isSelected = isSelected;
  //   notifyListeners();
  //   print('did set ${this.uid} to ${this.isSelected}');
  // }

  //   void addQuantity() {
  //   this.quantity = this.quantity + 1;
  //   notifyListeners();
  //   print('did set ${this.uid} to ${this.isSelected}');
  // }

  PreferenceItem copy(PreferenceItem item) {
    PreferenceItem newItem = PreferenceItem(
        item.uid, item.name, item.itemDescription,
        price: item.price);
    newItem.isSelected = item.isSelected;
    newItem.quantity = item.quantity;
    return newItem;
  }
}
