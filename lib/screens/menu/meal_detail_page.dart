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
  Meal meal;

  MealDetailPage(Meal meal) {
    // this.meal = meal;
    this.meal = Meal(meal.uid, meal.name, meal.price, meal.mealDescription,
        preferences: meal.preferences,
        comboMealTag: meal.comboMealTag,
        imageURL: meal.imageURL);
  }

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  ScrollController _scrollController;
  bool lastStatus = true;
  double appBarHeight = 0;
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
    Cart().meals.add(widget.meal);
    Navigator.pop(context);
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
              title: Text(isShrink ? 'Menu A' : '',
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
                subtitle: '99',
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
          // SizedBox(height: 8),
          TextButton(
              onPressed: () {
                print('go to special instruction');
              },
              child: Text(
                'Special instructions?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                SizedBox(width: 16),
                Text('1'),
                SizedBox(width: 16),
                Icon(Icons.remove),
              ],
            ),
          )
        ],
      ),
    );
  }
}
