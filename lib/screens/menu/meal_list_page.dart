import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/screens/menu/meal_list.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MealListPage extends StatelessWidget {
  final List<Meal> mealList = [
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png')
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: null,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: MealList(),
    );
  }
}
