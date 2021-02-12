import 'package:cafe_hollywood/screens/menu/meal_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/models/meal.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  MealTile(this.meal) {
    debugPrint('init: ${meal.name} image ${meal.imageURL}');
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(meal.name);
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MealDetailPage(meal, true)));
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Text(meal.details ?? '', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      if (meal.price.toString() != '0')
                        Text('\$${meal.price.toStringAsFixed(2) ?? ''}',
                            style: TextStyle(fontSize: 16)),
                      if (meal.price.toString() == '0') SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              if (meal.imageURL != null)
                Container(
                  margin: EdgeInsets.only(right: 8),
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
          )),
    );
  }
}
