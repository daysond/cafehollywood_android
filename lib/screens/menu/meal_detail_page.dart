import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:cafe_hollywood/screens/menu/item_tile.dart';
import 'package:cafe_hollywood/screens/menu/preference_tile.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';

class MealDetailPage extends StatefulWidget {
  final Meal meal;
  MealDetailPage(this.meal);
  // MealDetailPage(Meal meal) {
  //   // this.meal = meal;
  //   this.meal = Meal(
  //       meal.uid, meal.name, meal.price, meal.mealDescription, meal.details,
  //       preferences: meal.preferences,
  //       comboMealTag: meal.comboMealTag,
  //       imageURL: meal.imageURL);
  // }

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  ScrollController _scrollController;
  final instructionTextController = TextEditingController();
  bool lastStatus = true;
  double appBarHeight = 0;
  bool shouldHideBlackButton = false;
  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (appBarHeight - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void cartButtonTapped() {
    print('adding to cart');
    Meal newMeal = widget.meal.copy(widget.meal);
    Cart().addMealToCart(newMeal);
    resetMeal();
    Navigator.pop(context);
  }

  void resetMeal() {
    widget.meal.quantity = 1;
    widget.meal.preferences.forEach((preference) {
      preference.isSectionCollapsed = false;
      preference.preferenceItems.forEach((item) {
        item.quantity = 1;
        item.isSelected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    appBarHeight = screenSize.width * 9.0 / 16.0;
    return CupertinoPageScaffold(
      child: Stack(children: [
        CustomScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          slivers: [
            SliverAppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: isShrink ? Colors.black : Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(isShrink ? widget.meal.name : '',
                  style: TextStyle(
                    color: isShrink ? Colors.black : Colors.white,
                  )),
              backgroundColor: Colors.white,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                // title: Text('This is my menu'),
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.meal.imageURL == null
                          ? NetworkImage(
                              "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350")
                          : AssetImage('assets/${widget.meal.imageURL}'),
                    ),
                  ),
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.grey.withOpacity(0.0),
                                Colors.black.withOpacity(0.9),
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 32, 16),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.meal.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              widget.meal.details ?? '',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ]),
                    ),
                  ]),
                ),
              ),
              expandedHeight: MediaQuery.of(context).size.width * 9.0 / 16.0,
            ),
            if (widget.meal.preferences != null)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      PreferenceTile(widget.meal.preferences[index]),
                  childCount: widget.meal.preferences.length,
                ),
                //  SliverChildListDelegate(
                //     mealList.map((meal) => MealTile(meal)).toList()),
              ),
            SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildPreferenceFooter();
                  },
                  childCount: 1,
                ),
                itemExtent: 300),
          ],
        ),
        if (!shouldHideBlackButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: new BlackButton(
                  'Add To Cart',
                  cartButtonTapped,
                  subtitle: '${widget.meal.price}',
                ),
              ),
            ),
          ),
      ]),
    );
  }

  _buildPreferenceFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Special Instructions:'),
          SizedBox(height: 8),
          CupertinoTextField(
            placeholder: 'Any Special Instructions?',
            controller: instructionTextController,
            onTap: () {
              print('did tappp ta3pp tapp ');
              setState(() {
                shouldHideBlackButton = true;
              });
            },
            onEditingComplete: () {
              setState(() {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                shouldHideBlackButton = false;
                if (instructionTextController.text != '') {
                  print('hey');
                  widget.meal.instruction = instructionTextController.text;
                }
              });
            },
          ),
          // TextButton(
          //     onPressed: () {
          //       print('go to special instruction');
          //     },
          //     child: Text(
          //       'Special instructions?',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Colors.grey,
          //       ),
          //     )),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.meal.quantity++;
                    });
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 16),
                Text(widget.meal.quantity.toString()),
                SizedBox(width: 16),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.meal.quantity > 1) {
                          widget.meal.quantity--;
                        }
                      });
                    },
                    child: Icon(Icons.remove)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
