import 'package:cafe_hollywood/screens/menu/meal_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/models/meal.dart';
import 'package:decimal/decimal.dart';

class MealList extends StatelessWidget {
  final List<Meal> mealList = [
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png', details: 'my tea'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png', details: 'my coffee')
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mealList.length,
        itemBuilder: (context, index) {
          return MealTile(mealList[index]);
        });
  }
}
