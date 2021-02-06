import 'package:cafe_hollywood/models/menu.dart';
import 'package:cafe_hollywood/screens/menu/meal_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafe_hollywood/models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class MenuGridView extends StatefulWidget {
  // final List<Menu> menus;
  // MenuGridView(this.menus);
  @override
  _MenuGridViewState createState() => _MenuGridViewState();
}

class _MenuGridViewState extends State<MenuGridView> {
  @override
  Widget build(BuildContext context) {
    final foodMenus = Provider.of<List<Menu>>(context);

    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: foodMenus.length ?? 0,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.asset(
              'assets/${foodMenus[index].imageURL}',
              fit: BoxFit.cover,
            ),
            onTap: () {
              //TODO: GO TO A NEW CONTROLLER
              Navigator.push(context, CupertinoPageRoute(
                builder: (context) {
                  return ChangeNotifierProvider(
                      create: (context) => Cart(),
                      child: MealListPage(foodMenus[index]));
                },
              ));
              print('$index ${foodMenus[index].menuTitle}');
            },
          );
        });
  }
}
