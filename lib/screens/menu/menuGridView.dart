import 'package:cafe_hollywood/models/menu.dart';
import 'package:cafe_hollywood/screens/menu/meal_list_page.dart';
import 'package:cafe_hollywood/screens/shared/loading.dart';
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
  List<Menu> menus = [];

  @override
  void didChangeDependencies() {
    List<Menu> foodMenus = Provider.of<List<Menu>>(context);
    menus = foodMenus.where((element) => element.isAvailable).toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final foodMenus = Provider.of<List<Menu>>(context);

    // print('foodmenu ${foodMenus.length}');

    if (menus.length != []) {
      return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 8),
          itemCount: menus.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Image.asset(
                'assets/${menus[index].imageURL}',
                fit: BoxFit.cover,
              ),
              onTap: () {
                //TODO: GO TO A NEW CONTROLLER
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) {
                    return ChangeNotifierProvider(
                        create: (context) => Cart(),
                        child: MealListPage(menus[index]));
                  },
                ));
                print('$index ${menus[index].menuTitle}');
              },
            );
          });
    } else {
      return Center(
        child: Text('Loading'),
      );
    }
  }
}
