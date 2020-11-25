import 'package:flutter/material.dart';
import 'package:cafe_hollywood/models/meal.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  MealTile(this.meal);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(10, 6, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(meal.details, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('\$${meal.price.toString()}',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/${meal.imageURL}'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ],
        ));
  }
}
