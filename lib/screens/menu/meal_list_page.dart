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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Menu A'),
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              // title: Text('This is my menu'),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350"),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'title',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'subtitle',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ]),
                ),
              ),
            ),
            expandedHeight: 280,
          ),
        ],
      ),
    );

    // CupertinoPageScaffold(
    //   navigationBar: CupertinoNavigationBar(
    //     backgroundColor: null,
    //     leading: CupertinoNavigationBarBackButton(
    //       color: Colors.black,
    //       onPressed: () => Navigator.pop(context),
    //     ),
    //   ),
    //   child: MealList(),
    // );
  }
}
