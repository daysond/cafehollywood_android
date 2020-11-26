import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MealDetailPage extends StatefulWidget {
  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        child: Center(
          child: Text('meal'),
        ),
      ),
    );
  }
}
