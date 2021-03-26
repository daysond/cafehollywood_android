import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReceiptItemTile extends StatelessWidget {
  final MealInfo meal;
  ReceiptItemTile(this.meal);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                      width: 18,
                      color: Colors.grey[350],
                      child:
                          Center(child: Text(meal.quantity.toString() ?? ''))),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    meal.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Text(meal.totalPrice.toString()),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 8, 8),
              child: meal.instruction != null
                  ? Text('${meal.addOnInfo}${meal.instruction}' ?? '')
                  : Text(meal.addOnInfo ?? ''),
            )
          ],
        ));
  }
}
