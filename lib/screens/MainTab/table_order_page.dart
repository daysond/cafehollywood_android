import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:cafe_hollywood/models/table.dart';
import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:flutter/cupertino.dart';

class TableOrderPage extends StatefulWidget {
  @override
  _TableOrderPageState createState() => _TableOrderPageState();
}

class _TableOrderPageState extends State<TableOrderPage> {
  Map<String, List> data = {
    if (DineInTable().unconfirmedMeals.length != 0)
      'Unconfirmed': DineInTable().unconfirmedMeals,
    if (DineInTable().confirmedMeals.length != 0)
      'Confirmed': DineInTable().confirmedMeals,
    if (DineInTable().cancelledMeals.length != 0)
      'Canceled': DineInTable().cancelledMeals
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Table ${DineInTable().tableNumber} Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: data.length == 0
          ? Center(
              child: Text(
                'Browse menu and start order!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            )
          : GroupListView(
              sectionsCount: data.keys.toList().length,
              countOfItemInSection: (int section) {
                return data.values.toList()[section].length;
              },
              itemBuilder: _itemBuilder,
              groupHeaderBuilder: (BuildContext context, int section) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Text(
                    data.keys.toList()[section],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
              sectionSeparatorBuilder: (context, section) =>
                  SizedBox(height: 10),
            ),
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    MealInfo meal = data.values.toList()[index.section][index.index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
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
                        child: Center(child: Text(meal.quantity.toString()))),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text(
                      meal.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    Text(meal.totalPrice.toString()),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 8, 8),
                  child: Text('${meal.addOnInfo}${meal.instruction}'))
            ],
          )),
    );
  }
}
