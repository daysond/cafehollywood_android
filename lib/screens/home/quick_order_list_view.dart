import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cafe_hollywood/screens/menu/meal_detail_page.dart';

class QuickOrderListView extends StatefulWidget {
  @override
  _QuickOrderListViewState createState() => _QuickOrderListViewState();
}

class _QuickOrderListViewState extends State<QuickOrderListView> {
  var fsService = FSService();

  @override
  void initState() {
    // TODO: implement initState
    APPSetting().updateFavDelegate = updateView;
    APPSetting().favouriteMealList().then((value) {
      if (value.length != 0) {
        if (value.length != APPSetting().favouriteMeals.length) {
          List<String> listToGet = [];
          value.forEach((uid) {
            if (!APPSetting()
                .favouriteMeals
                .map((e) => e.uid)
                .toList()
                .contains(uid)) listToGet.add(uid);
          });
          fsService.getMeals(listToGet).then((value) {
            value.forEach((element) {
              APPSetting().recoverMealPreferenceData(element);
            });
            setState(() {
              APPSetting().favouriteMeals.addAll(value);
            });
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    APPSetting().favouriteMeals.forEach((element) {
      element.isSelected = false;
    });
    APPSetting().updateFavDelegate = null;
    super.dispose();
  }

  void updateView() {
    setState(() {});
  }

  void addToCartTapped() {
    APPSetting()
        .favouriteMeals
        .where((e) => e.isSelected)
        .toList()
        .forEach((meal) {
      Cart().addMealToCart(meal);
    });

    Navigator.pop(context);
  }

  bool shouldEnableButton() {
    bool shouldEnable = false;
    for (var meal in APPSetting().favouriteMeals) {
      if (meal.isSelected && APPSetting().unavailableMeals.contains(meal.uid))
        return false;
      if (meal.isSelected && meal.isModificationRequired) {
        return false;
      } else if (meal.isSelected && !meal.isModificationRequired) {
        shouldEnable = true;
      }
    }
    return shouldEnable;
  }

  @override
  Widget build(BuildContext context) {
    // return Text("");
    return SafeArea(
      child: Container(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Quick Order From Favourite',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: APPSetting().favouriteMeals.length,
                    itemBuilder: (context, index) {
                      return FavMealTile(
                          APPSetting().favouriteMeals[index], updateView);
                    }),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: BlackButton(
                      'Add To Cart', addToCartTapped, shouldEnableButton()))
            ]),
          )),
    );
  }
}

class FavMealTile extends StatefulWidget {
  final Meal meal;
  final void Function() updateViewCallBack;
  FavMealTile(this.meal, this.updateViewCallBack);

  @override
  _FavMealTileState createState() => _FavMealTileState();
}

class _FavMealTileState extends State<FavMealTile> {
  void didUpdateModification() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (APPSetting().unavailableMeals.contains(widget.meal.uid)) return;
        setState(() {
          widget.meal.isSelected = !widget.meal.isSelected;
          widget.updateViewCallBack.call();
        });
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              if (widget.meal.isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.black,
                  size: 16,
                ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    APPSetting().unavailableMeals.contains(widget.meal.uid)
                        ? Text(
                            widget.meal.name + ' - Unavailable',
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        : Text(widget.meal.name),
                    SizedBox(height: 8),
                    Text('\$' + widget.meal.price.toString()),
                    SizedBox(height: 8),
                    widget.meal.isModificationRequired
                        ? Text(
                            "Please selected the required option(s).",
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          )
                        : Text(
                            widget.meal.addOnInfo,
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => MealDetailPage(
                                  widget.meal,
                                  true,
                                  true,
                                  modifierCallBack: didUpdateModification,
                                )));
                  },
                  child: Icon(Icons.edit))
            ],
          ),
        ),
      ),
    );
  }
}
