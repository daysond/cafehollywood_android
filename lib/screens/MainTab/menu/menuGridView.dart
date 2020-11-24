import 'package:cafe_hollywood/models/menu.dart';
import 'package:flutter/material.dart';

class MenuGridView extends StatefulWidget {
  final List<Menu> menus;
  MenuGridView(this.menus);
  @override
  _MenuGridViewState createState() => _MenuGridViewState();
}

class _MenuGridViewState extends State<MenuGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: widget.menus.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.asset(
              'assets/${widget.menus[index].imageURL}',
              fit: BoxFit.cover,
            ),
            onTap: () {
              //TODO: GO TO A NEW CONTROLLER
              print('$index ${widget.menus[index].menuTitle}');
            },
          );
        });
  }
}
