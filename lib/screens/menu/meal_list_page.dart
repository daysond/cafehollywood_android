import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/models/menu.dart';
import 'package:cafe_hollywood/models/preference.dart';
import 'package:cafe_hollywood/models/preference_item.dart';
import 'package:cafe_hollywood/screens/menu/meal_tile.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/models/cart.dart';
import 'package:provider/provider.dart';

class MealListPage extends StatefulWidget {
  final Menu menu;
  MealListPage(this.menu);

  @override
  _MealListPageState createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  final List<Meal> mealList = [
    Meal('301', 'Coffee', Decimal.parse('3.20'), 'this is coffee 301',
        imageURL: 'wings.png',
        preferences: [
          Preference('uid', true, 'p1', 1, 1, [
            PreferenceItem(
                'item1', 'item1name', 'this isitem 1', Decimal.parse('1.5'), 1),
            PreferenceItem(
                'item2', 'item2name', 'this is item 2', Decimal.parse('1.3'), 1)
          ]),
          Preference('uid2', true, 'preference2', 2, 2, [
            PreferenceItem('item1', 'p2 i1 name', 'this isitem 1',
                Decimal.parse('1.5'), 1),
            PreferenceItem('item2', 'p2 i2 name', 'this is item 2',
                Decimal.parse('1.3'), 1)
          ])
        ]),
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'wings.png'),
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'wings.png'),
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png'),
    Meal('300', 'Tea', Decimal.parse('2.5'), 'this is Tea',
        imageURL: 'wings.png'),
    Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'wings.png'),
  ];

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

  void viewCartButtonHandler() {
    // setState(() {});
    var meal = Meal('301', 'Coffee', Decimal.parse('1.5'), 'this is coffee',
        imageURL: 'hwcb.png');
    Cart().addMealToCart(meal);
    print('view cart ${Cart().meals.length} ${Cart().cartTotal}');
  }

  @override
  Widget build(BuildContext context) {
    print(widget.menu.mealsInUID);

    Size screenSize = MediaQuery.of(context).size;
    appBarHeight = screenSize.width * 9.0 / 16.0;
    return ChangeNotifierProvider(
      create: (_) => Cart(),
      child: CupertinoPageScaffold(
        child: Stack(children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: isShrink ? Colors.black : Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                expandedHeight: screenSize.width * 9.0 / 16.0,
                backgroundColor: Colors.white,
                title: Text(isShrink ? 'Menu A' : '',
                    style: TextStyle(
                      color: isShrink ? Colors.black : Colors.white,
                    )),
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
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
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => MealTile(mealList[index]),
                  childCount: mealList.length,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Consumer<Cart>(builder: (context, cart, child) {
                  return BlackButton('View Cart', viewCartButtonHandler,
                      subtitle: '\$${cart.cartTotal.toString()}');
                }),
              ),
            ),
          ),
        ]),
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
